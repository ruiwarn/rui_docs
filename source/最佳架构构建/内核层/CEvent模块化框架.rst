CEvent模块化框架
================

简介
----

对于模块化编程来说，如何实现各模块间的解耦一直是一个比较令人头疼的问题，特别是对于嵌入式编程，由于控制逻辑复杂，并且对程序体积有控制，经常容易写出各独立模块之间相互调用的问题。
由此，CEvent模块化框架，通过模仿Android系统中的广播机制，提供了一种非常简单的模块间解耦实现。


设计理念
--------

cevent借鉴的是Android系统的广播机制，一方面，各模块在工作的时候，都会有多个具体的事件点，在高耦合的编程中，可能会在这些地方调用其他模块的功能，比如说，在通信模块接收到指令的时候，需要闪烁一下指示灯
使用cevent，我们可以在这些地方抛出一个事件，当前模块不需要关心在这各地方需要执行哪些其他模块的逻辑，由其他模块，或者用户定义一个事件监听，当具体的事件发生时，执行相应的动作

CEvent 框架的核心设计理念包括：

1. 合理利用底层编译原理：利用宏定义，在编译期完成生产者和消费者的绑定
2. 事件驱动：模块间通过事件进行通信，减少直接依赖。
3. 松耦合：模块之间的接口通过事件定义，降低模块间的耦合度。
4. 可扩展性：易于添加新模块或修改现有模块，而不影响其他部分。

框架结构
--------

CEvent 框架主要包含以下组件：

1. 事件定义（Event Definition）
2. 模块结构（Module Structure）
3. 事件分发器（Event Dispatcher）
4. 模块管理器（Module Manager）

应用举例1
--------------

嵌入式编程中，我们习惯会在程序启动的时候，调用各个模块的初始化函数，
其实这也是一种耦合，会造成main函数中出现很长的初始化代码，借助cevent，我们可以对初始化进行优化解耦

**1. 定义初始化事件**

定义初始化事件的值，对于初始化，有些模块可能会依赖于其他模块的初始化，会有一个先后顺序要求，所以这里我们可以把初始化分成两个阶段，定义两个事件，当然，如果有更复杂的要求，可以再多分几个阶段，只需要多定义几个事件就行

事件是模块间通信的基本单位，通常定义为一个宏类型：

.. code-block:: c

    #define PRINT_SYSTEM_INITIALIZATION  0          //打印系统初始化
    #define ON_CHIP_AND_OFF_CHIP_INITIALIZATION  1  //片内外设初始化
    #define INITIALIZATION_OF_ONBOARD_PERIPHERALS 2 //板上外设初始化
    #define SOFTWARE_INITIALIZATION 3  //软件系统初始化


**2. 注册打印串口驱动初始化事件**

第一个函数为初始化函数，重点关注后面的 ``CEVENT_EXPORT``

.. code-block:: c

    en_result_t UART_PrintfInit(M4_USART_TypeDef *UARTx,
                            uint32_t u32Baudrate,
                            void (*PortInit)(void))
    {
        en_result_t enRet = ErrorInvalidParameter;
        
        if (IS_VALID_UART(UARTx) && (0ul != u32Baudrate) && (NULL != PortInit))
        {
            /* Initialize port */
            PortInit();
            
            /* Enable clock */
            UART_EnableClk(UARTx);
            
            /* Initialize USART */
            UARTx->CR1_f.ML = 0ul;      /* LSB */
            UARTx->CR1_f.MS = 0ul;      /* UART mode */
            UARTx->CR1_f.OVER8 = 1ul;   /* 8bit sampling mode */
            UARTx->CR1_f.M = 0ul;       /* 8 bit data length */
            UARTx->CR1_f.PCE = 0ul;     /* no parity bit */
            
            /* Set baudrate */
            if (Ok != SetUartBaudrate(UARTx, u32Baudrate))
            {
                enRet = Error;
            }
            else
            {
                UARTx->CR2 = 0ul;       /* 1 stop bit, single uart mode */
                UARTx->CR3 = 0ul;       /* CTS disable, Smart Card mode disable */
                UARTx->CR1_f.TE = 1ul;  /* TX enable */
                
                m_PrintfDevice = UARTx;
                m_u32PrintfTimeout = (SystemCoreClock / u32Baudrate);
            }
        }
        
        return enRet;
    }

    CEVENT_EXPORT(PRINT_SYSTEM_INITIALIZATION, UART_PrintfInit,
                BSP_PRINTF_DEVICE, BSP_PRINTF_BAUDRATE, BSP_PRINTF_PortInit);


**3. 在main函数中解耦调用事件**

如下代码， 在 ``ceventPost`` 调用的地方会自动将打印串口初始化的函数从 ``段内`` 取出来进行调用，main函数不在依赖特定的接口

.. code-block:: c

   int main(void)
    {
        ceventInit();

        ceventPost(PRINT_SYSTEM_INITIALIZATION);
        ...
        for (;;)
        {
            ...
        }
        
        return 0;
    }

应用举例2
--------------

使用 ``cevent`` 解耦 ``mainloop`` 

在无操作系统的嵌入式编程中，我们如果同时希望运行多个模块的逻辑，通常是在mainloop中循环调用，这种将函数写入mainloop的做法，也会增加耦合。

在线程中的调用任务接口也是一样的道理。通过 ``cevent`` 就能解决这种痛点。

**1. 定义mainloop事件**

.. code-block:: c

   #define     EVENT_MAIN_LOOP         4

**2. 在mainloop中调用所有** ``CEVENT_EXPORT`` **注册为** ``EVENT_MAIN_LOOP`` **的事件**

.. code-block:: c

   int main(void)
    {
        ...

        while (1)
        {
            ceventPost(EVENT_MAIN_LOOP);
        }
        return 0;
    }

优势
----

1. 模块化设计：每个功能均能依赖cevent进行模块化设计，不在互相调用。
2. 高内聚：使每个模块专注于特定功能并且能独立编译，提高代码的可读性和可维护性。
3. 可扩展性：易于添加新模块或修改现有模块，而不影响其他部分。
4. 段技巧：利用段操作技巧，解耦方法相当于直接调用，效率极高。

结论
----

CEvent 模块化框架为嵌入式系统提供了一种灵活、可扩展的软件架构方案。通过采用这种框架，开发者可以更好地组织代码，提高系统的可维护性和可扩展性。
在实际应用中，应根据具体项目需求和硬件限制来调整和优化框架的实现。
