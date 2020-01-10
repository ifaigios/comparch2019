1ο εργαστήριο

1. starter_se.py

- CPU type = minor
- CPU cores = 1
- CPU clock = 1GHz
- CPU voltage domain = 1.2V
- memory size = 2GB
- memory type = DDR3 1600MHz 8x8 dual channel
- system voltage domain = 3.3V

2. config.ini

CPU type:
[system.cpu_cluster.cpus]
type=MinorCPU

clock:
[system.clk_domain]
clock=1000

cores:
[system.cpu_cluster.cpus]
numThreads=1

CPU voltage domain:
[system.cpu_cluster.voltage_domain]
voltage=1.2

memory size & type:
[system.mem_ctrls0]
VDD=1.5
banks_per_rank=8
devices_per_rank=8
device_size=536870912
ranks_per_channel=2
[system.mem_ctrls1]
VDD=1.5
banks_per_rank=8
devices_per_rank=8
device_size=536870912
ranks_per_channel=2

system voltage domain:
[system.voltage_domain]
voltage=3.3
 
3. CPU types:

* AtomicSimpleCPU
* TimeSimpleCPU
* O3CPU
* InOrderCPU
   * -> MinorCPU

Στο se.py :

(choose CPU from 'O3_ARM_v7a_3', 'AtomicSimpleCPU', 'TraceCPU', 'ex5_big', 'DerivO3CPU', 'MinorCPU', 'HPI', 'ex5_LITTLE', 'NonCachingSimpleCPU', 'TimingSimpleCPU')

a)
* AtomicSimpleCPU time: 1.34 seconds
* TimingSimpleCPU time: 6.05 seconds
* MinorCPU time: 7.24 seconds

b)
Τα AtomicSimpleCPU και τα TimingSimpleCPU είναι απλά μοντέλα εκτέλεσης, οπότε είναι και πιο γρήγορα. Ενώ από την άλλη μεριά, το MinorCPU είναι detailed in-order μοντέλο εκτέλεσης και ως εκ τούτου αρκετά πιο αργό. Σημειωτέον ότι για το MinorCPU χρησιμοποιήθηκε η (υποχρεωτική) επιλογή --caches , και παρ’ όλα αυτά το detailed μοντέλο είναι πιο αργό από τα simple μοντέλα χωρίς καθόλου caches.

c) 
- με 1MB μνήμη αντί για 1024ΜΒ:

* AtomicSimpleCPU time: 1.35 seconds
* TimingSimpleCPU time: 6.23 seconds
* MinorCPU time: 7.40 seconds

παρατηρούμε ότι με την δραματική μείωση της διαθέσιμης RAM, όλα τα μοντέλα επιβραδύνονται

- με 10MHz ρολόι αντί για 1GHz

* AtomicSimpleCPU time: 1.34 seconds
* TimingSimpleCPU time: 11.55 seconds
* MinorCPU time: 7.82 seconds

παρατηρούμε ότι με τη δραματική μείωση του ρολογιού το AtomicSimpleCPU model μένει ανεπηρέαστο, το MinorCPU επιβραδύνεται λίγο, ενώ το TimingSimpleCPU επιβραδύνεται αρκετά

Πηγές:

https://raw.githubusercontent.com/arm-university/arm-gem5-rsk/master/gem5_rsk.pdf

