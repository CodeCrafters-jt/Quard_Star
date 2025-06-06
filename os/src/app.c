#include <timeros/os.h>
uint64_t syscall(size_t id, reg_t arg1, reg_t arg2, reg_t arg3) {

    register uintptr_t a0 asm ("a0") = (uintptr_t)(arg1);
    register uintptr_t a1 asm ("a1") = (uintptr_t)(arg2);
    register uintptr_t a2 asm ("a2") = (uintptr_t)(arg3);
    register uintptr_t a7 asm ("a7") = (uintptr_t)(id);

    asm volatile ("ecall"
		      : "+r" (a0)
		      : "r" (a1), "r" (a2), "r" (a7)
		      : "memory");
    return a0;
}

uint64_t sys_write(size_t fd, const char* buf, size_t len)
{
    return syscall(__NR_write,fd,buf, len);
}

uint64_t sys_yield()
{
    return syscall(__NR_sched_yield,0,0,0);
}

uint64_t sys_gettime()
{
    return syscall(__NR_gettimeofday,0,0,0);
}



void task1()
{
    const char *message = "task1 is running!\n";
    int len = strlen(message);
    while (1)
    {
       //printf(message);
    }
}


void task2()
{
    const char *message = "task2 is running!\n";
    int len = strlen(message);
    while (1)
    {
       //printf(message);
    }
}

void task3()
{
    const char *message = "task3 is running!\n";
    int len = strlen(message);

    uint64_t current_timer = 0;
    uint64_t wait_for = current_timer + 500;
    while (1)
    {
       current_timer = sys_gettime();
       printf("current_timer:%d\n",current_timer);
    }
    
}


// void task_init(void)
// {
// 	task_create(task1);
// 	task_create(task2);
//     task_create(task3);
// }