trigger OrderProductTrigger on OrderItem (after insert, after update) {
    new OrderProductHandler().run();
}