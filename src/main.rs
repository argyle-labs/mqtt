//! Dynamic (subprocess) entrypoint for the mqtt plugin.
//!
//! The toolkit's `serve_service_plugin!` emits `fn main`, serving this plugin over the orca
//! socket. The plugin is a
//! `[[bin]]`, owns no runtime, and reaches orca only through the socket.
plugin_toolkit::serve_service_plugin! {
    name: "mqtt",
    target_compat: "any",
    backend: mqtt::MqttBackend::new("mqtt"),
}
