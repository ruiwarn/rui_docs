面向对象 for C
==============

虽然C语言不是一种面向对象的编程语言,但我们可以通过一些技巧来模拟面向对象编程的概念。以下是在C语言中实现面向对象编程的一些方法:

封装
----

封装可以通过使用结构体和函数指针来实现:

.. code-block:: c

   typedef struct {
       int x;
       int y;
       void (*move)(struct Point*, int, int);
   } Point;

   void point_move(Point* self, int dx, int dy) {
       self->x += dx;
       self->y += dy;
   }

   Point* point_new(int x, int y) {
       Point* p = malloc(sizeof(Point));
       p->x = x;
       p->y = y;
       p->move = point_move;
       return p;
   }

继承
----

继承可以通过在子结构体中包含父结构体来实现:

.. code-block:: c

   typedef struct {
       Point base;
       int radius;
   } Circle;

   Circle* circle_new(int x, int y, int radius) {
       Circle* c = malloc(sizeof(Circle));
       c->base = *point_new(x, y);
       c->radius = radius;
       return c;
   }

多态
----

多态可以通过函数指针和void指针来实现:

.. code-block:: c

   typedef struct {
       void (*draw)(void*);
   } Shape;

   void circle_draw(void* shape) {
       Circle* c = (Circle*)shape;
       // 绘制圆的代码
   }

   void point_draw(void* shape) {
       Point* p = (Point*)shape;
       // 绘制点的代码
   }

   // 使用多态
   Shape shapes[] = {
       {circle_draw},
       {point_draw}
   };

   for (int i = 0; i < 2; i++) {
       shapes[i].draw(&shapes[i]);
   }

.. note::
    虽然C语言不直接支持面向对象编程,但通过这些技巧,我们可以在C中模拟面向对象的主要特性。这种方法虽然不如真正的面向对象语言那样直观和简洁,但在某些情况下可能是必要的,特别是在嵌入式系统或需要高度控制内存管理的场景中。
    然而,需要注意的是,这种方法增加了代码的复杂性,可能会影响可读性和维护性。因此,在选择使用这种方法时,应该权衡其利弊,并考虑是否有更合适的替代方案。
