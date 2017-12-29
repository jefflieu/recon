#include <system.h>
#include <sys/alt_sys_init.h>
#include <sys/alt_irq.h>

void setup();
void loop();

int main(void)
{
  alt_sys_init();
  alt_irq_init(0);
  
  setup();
  
  while(1)
    {
      loop();
    }
  
}

