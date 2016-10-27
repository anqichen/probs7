# Parallel Count Sort Algorithm with OpenMP

## CMSE 822: Parallel Computing, Fall 2016, MSU

In this exercise, you will apply a few advanced OpenMP directives to parallelize the Count Sort algorithm. This homework is based on material from Prof. M. Aktulga.

For background, briefly review the Count Sort method at <https://en.wikipedia.org/wiki/Counting_sort>. The kernel of the algorithm in `C` is

```c
void count_sort(int a[], int n) { int i, j, count;
  int *temp = malloc(n*sizeof(int));
  for (i = 0; i < n; i++) {
    count = 0;
    for (j = 0; j < n; j++)
      if (a[j] < a[i])
        count++;
      else if (a[j] == a[i] && j < i)
        count++;
      temp[count] = a[i];
  }
  memcpy(a, temp, n*sizeof(int));
  free(temp);
} /* Count sort */
```

The basic idea is that for each element `a[i]`, we count the number of elements in a that are less than `a[i]`. Then we insert `a[i]` into the `temp` list using the subscript determined by count. There's a slight problem with this approach when the list contains equal elements, since they could get assigned to the same slot in `temp`. The code deals with this by incrementing count for equal elements on the basis of the subscripts. If both `a[i] == a[j]` and `j < i`, then we count `a[j]` as being "less than" `a[i]`. After the algorithm has completed, we overwrite the original array with the temporary array using the string library function memcpy. A serial implementation is provided in the repo (count_sort_serial.c) that should be used for validation and speedup. This code should be compiled using the OpenMP flag `-fopenmp`, i.e., `gcc -O0 -fopenmp count_sort_serial.c`

1. Implement two different OpenMP parallel versions of the count sort algorithm: first by parallelizing the `i`-loop, and second one by parallelizing the `j`-loop. In both versions, modify the code so that the `memcpy` part can also be parallelized.

2. Compare the running time of your OpenMP implementations on multiple threads (e.g. 1, 2, 4, 8, 10, 16, and 24 threads) on a single intel16 node at HPCC. Plot total running time vs. number threads (include curves for both the i-loop and j-loop versions in a single plot) for a fixed value of n. A good choice for n would be in the range 50,000 to 100,000.

**Measuring your execution time properly:** The omp_get_wtime() command will allow you to measure the timing for a particular part of your program (see the serial codes). However, on the dev-nodes there will be several other programs running simultaneously, and your measurements will not be accurate. After you make sure that your program is bug-free and executes correctly on the dev-nodes, the way to get good performance data for different programs and various input sizes is to i) use a job script for your runs, or ii) use the interactive queue. Suggested options for starting an interactive queue on intel14 and intel14-phi are as follows:

`qsub -I -l nodes=1:ppn=28,walltime=00:30:00 -N myjob`

Sometimes getting access to a node interactively may take very long. In that case, I recommend you to create a job script with the above options, and submit it to the queue (this may still take a couple hours, but at least you do not have to sit in front of the computer). Note that you can execute several runs of your programs with different input values in the same job script – this way you can avoid submitting and tracking several jobs. The options above will allow exclusive access to a node for 30 minutes. If you ask for a long job, your job may get delayed. Note that default memory per job is 750 MBs, which should be plenty for the problems in this assignment. But if you will need more memory, you need to specify it in the job script.
