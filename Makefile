CC=gcc
FC=gfortran
CFLAGS=-c
FFLAGS=-O0 -g
FFLAGS_OPT=-O2

all: count_sort

count_sort: get_walltime.o dummy.o quickSort.o .FORCE
		$(FC) $(FFLAGS) count_sort.f90 quickSort.o dummy.o get_walltime.o -o countSort

quickSort.o:
			  $(FC) $(FFLAGS) -c quickSort.f90

dummy.o:
	  $(FC) $(FFLAGS) -c dummy.f90

get_walltime.o:
	$(CC) $(CFLAGS) get_walltime.c

.FORCE:

clean:
	rm *.o spmv
