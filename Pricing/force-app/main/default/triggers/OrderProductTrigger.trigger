trigger OrderProductTrigger on OrderItem (before insert, before update) {
    new OrderProductHandler().run();
}