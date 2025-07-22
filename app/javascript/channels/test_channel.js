import consumer from "channels/consumer"

consumer.subscriptions.create("TestChannel", {
  connected() {
    console.log("Connected to TestChannel");
  },

  disconnected() {
    console.log("Disconnected from TestChannel");
  },

  received(data) {
    console.log("Received from TestChannel:", data);
  }
});
