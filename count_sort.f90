program countSort
  use qsort_c_module, ONLY : QsortC
  implicit none

  character (len=32):: arg
  integer :: status, n
  double precision :: S,E
  integer :: i,j, count
  integer, allocatable :: a(:), b(:), temp(:)
  real, allocatable :: c(:)

  call get_command_argument(1,arg,status)
  read(arg, '(I10)') n

  call initList(a,n)
  allocate(temp(n))
  allocate(b(n))
  c = a

  call get_walltime(S)
  do i=1,n
     count = 1
     do j=1,n
        if (a(j) < a(i)) then
           count = count + 1
        else if ((a(j)==a(i)) .AND. (j<i)) then
           count = count + 1
        end if
     end do
     temp(count) = a(i)
  end do
  a = temp
  call get_walltime(E)

  call QsortC(c)
  b = int(c)

  print *, (E-S), difference(a,b,n)

contains

  subroutine initList(a,n)
    integer, intent(IN) :: n
    integer, allocatable, intent(OUT) :: a(:)
    integer :: i
    real :: tmp
    allocate(a(n))
    do i = 1, n
       call random_number(tmp)
       a(i) = int(tmp*1000)
    end do
  end subroutine initList

  real function difference(a,b,n)
    integer, intent(IN) :: n
    integer, dimension(n), intent(IN) :: a, b
    difference = sum(a-b)
  end function difference

end program countSort
