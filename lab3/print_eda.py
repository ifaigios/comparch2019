#!/usr/bin/python2
import sys
import re
import os
import json
import types
import math
import StringIO
import subprocess as subp
from optparse import OptionParser

mcpat_bin = "mcpat"

class parse_node:
    def __init__(this,key=None,value=None,indent=0):
        this.key = key
        this.value = value
        this.indent = indent
        this.leaves = []
    
    def append(this,n):
        #print 'adding parse_node: ' + str(n) + ' to ' + this.__str__() 
        this.leaves.append(n)

    def get_tree(this,indent):
        padding = ' '*indent*2
        me = padding + this.__str__()
        kids = map(lambda x: x.get_tree(indent+1), this.leaves)
        return me + '\n' + ''.join(kids)
        
    def getValue(this,key_list):
        #print 'key_list: ' + str(key_list)
        if (this.key == key_list[0]):
            #print 'success'
            if len(key_list) == 1:
                return this.value
            else:
                kids = map(lambda x: x.getValue(key_list[1:]), this.leaves)
                #print 'kids: ' + str(kids) 
                return ''.join(kids)
        return ''        
        
    def __str__(this):
        return 'k: ' + str(this.key) + ' v: ' + str(this.value)

class parser:
    def dprint(this,astr):
        if this.debug:
            print this.name,
            print astr

    def __init__(this, data_in):
        this.debug = False
        this.name = 'mcpat:mcpat_parse'

	buf = open(data_in)
      
        this.root = parse_node('root',None,-1)
        trunk = [this.root]

        for line in buf:
            	   
            indent = len(line) - len(line.lstrip())
            equal = '=' in line
            colon = ':' in line
            useless = not equal and not colon
            items = map(lambda x: x.strip(), line.split('='))

            branch = trunk[-1]

            if useless: 
                #this.dprint('useless')
                pass 

            elif equal:
                assert(len(items) > 1)

                n = parse_node(key=items[0],value=items[1],indent=indent)
                branch.append(n)

                this.dprint('new parse_node: ' + str(n) )

            else:
                while ( indent <= branch.indent):
                    this.dprint('poping branch: i: '+str(indent) +\
                                    ' r: '+ str(branch.indent))
                    trunk.pop()
                    branch = trunk[-1]
                
                this.dprint('adding new leaf to ' + str(branch))
                n = parse_node(key=items[0],value=None,indent=indent)
                branch.append(n)
                trunk.append(n)
                
    def get_tree(this):
        return this.root.get_tree(0)

    def getValue(this,key_list):
        value = this.root.getValue(['root']+key_list) 
        assert(value != '')
        return value

def readMcPAT(mcpatoutputFile):
    p = parser(mcpatoutputFile)
    
    peak = p.getValue(['Processor:', 'Peak Power'])
    peak = re.sub(' W','', peak) 
    
    corearea = p.getValue(['Core:', 'Area'])
    coresub = p.getValue(['Core:', 'Subthreshold Leakage'])
    coregate = p.getValue(['Core:', 'Gate Leakage'])
    coredynamic = p.getValue(['Core:', 'Runtime Dynamic'])
    corearea = re.sub(" mm\^2",'', corearea) 
    coresub = re.sub(' W','', coresub) 
    coregate = re.sub(' W','', coregate) 
    coredynamic = re.sub(' W','', coredynamic) 

    l2area = p.getValue(['L2:', 'Area'])
    l2sub = p.getValue(['L2:', 'Subthreshold Leakage'])
    l2gate = p.getValue(['L2:', 'Gate Leakage'])
    l2dynamic = p.getValue(['L2:', 'Runtime Dynamic'])

    l2area = re.sub(' mm\^2','', l2area) 
    l2sub = re.sub(' W','', l2sub) 
    l2gate = re.sub(' W','', l2gate) 
    l2dynamic = re.sub(' W','', l2dynamic)

    coreleakage = float(coresub) + float(coregate)
    l2leakage = float(l2sub) + float(l2gate)
    leakage = coreleakage + l2leakage
    dynamic = float(coredynamic) + float(l2dynamic)
    area = float(corearea) + float(l2area)
    peak = float(peak)

    return (leakage, dynamic, area, peak)

def getTimefromStats(statsFile):
    F = open(statsFile)
    ignores = re.compile(r'^---|^$')
    statLine = re.compile(r'([a-zA-Z0-9_\.:+-]+)\s+([-+]?[0-9]+\.[0-9]+|[0-9]+|nan+|inf)')

    for line in F:
        #ignore empty lines and lines starting with "---"  
        if not ignores.match(line):
            statKind = statLine.match(line).group(1)
            statValue = statLine.match(line).group(2)
            if statKind == 'sim_seconds':
                runtime = float(statValue)
            if statKind == 'system.cpu.cpi':
                cpi = float(statValue)
            if statKind == 'system.cpu.icache.overall_miss_rate::total':
                l1i_miss = float(statValue)                
            if statKind == 'system.cpu.dcache.overall_miss_rate::total':
                l1d_miss = float(statValue)
            if statKind == 'system.l2.overall_miss_rate::total':
                l2_miss = float(statValue)                
	#	break	# no need to parse the whole file once the requested value has been found
    F.close()
    return (runtime, cpi, l1i_miss, l1d_miss, l2_miss)

def main():
    global opts
    usage = "usage: %prog [options] <mcpat output file> <gem5 stats file>"
    parser = OptionParser(usage=usage)
    parser.add_option("-q", "--quiet", 
        action="store_false", dest="verbose", default=True,
        help="don't print status messages to stdout")
    
    (opts, args) = parser.parse_args()
    if len(args) != 2:
        parser.print_help()
        sys.exit(1)
        
    runtime, cpi, l1i_miss, l1d_miss, l2_miss = getTimefromStats(args[1])   
    leakage, dynamic, area, peak = readMcPAT(args[0])
    energy = (leakage + dynamic) * runtime
    eda = energy * runtime * area

    print "%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f" % (cpi, l1i_miss, l1d_miss, l2_miss, peak, energy, runtime, area, eda)

if __name__ == '__main__':
    main()

