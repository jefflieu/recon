#include <system.h>
#include <sys/alt_sys_init.h>
#include <sys/alt_irq.h>


void setup();
void loop();

int main(void)
{
  /* Altera sepcific */
  alt_irq_init(0);
  alt_sys_init();
  
  setup();
  
  while(1)
    {
      loop();
    }
  
}

