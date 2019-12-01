#include <stdio.h>
#include <math.h>

int main() {
float result = 0;

// run 100.000 sqrt calculations
for (int i = 0; i < 100000; ++i) {
    result += sqrt(i);
}

return 0;
}
