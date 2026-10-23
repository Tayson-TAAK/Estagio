trigger Order on Order (before update) {
    new OrderHandler().run();
}