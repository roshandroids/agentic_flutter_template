/// Read-only metadata about the modules currently enabled - see
/// modules/README.md "Module registry (diagnostics only)". This exists so
/// tooling (the Playground's Modules screen, `doctor.sh`, an eventual
/// Architecture Explorer) can answer "what's enabled and what does it
/// implement?" without parsing source.
///
/// This is NOT a service locator and NOT how dependency injection happens:
/// `apps/app/lib/composition_root.dart` remains the single place that
/// constructs a module and binds it to its contract's provider. The
/// registry is built by hand, in that same file, listing descriptors for
/// modules already wired - never by reflection or filesystem scanning, and
/// nothing resolves a module *through* it.
class ModuleDescriptor {
  const ModuleDescriptor({
    required this.id,
    required this.version,
    required this.capabilities,
    this.hasLifecycle = false,
  });

  /// Matches the module's directory name under `modules/` and its entry in
  /// `template.config.yaml`'s `modules.enabled` list.
  final String id;

  final String version;

  /// The `module_contracts` interfaces this module implements, e.g.
  /// `{'AnalyticsModule'}` - free-form strings rather than `Type` so a
  /// descriptor can be declared without importing every contract.
  final Set<String> capabilities;

  /// Whether this module has explicit start/stop work
  /// (`composition_root.dart` calls `init`/`dispose` itself; the registry
  /// only reports that it should).
  final bool hasLifecycle;
}

/// An explicit, hand-built list of the modules currently enabled.
class ModuleRegistry {
  const ModuleRegistry(this.modules);

  final List<ModuleDescriptor> modules;

  bool get isEmpty => modules.isEmpty;

  /// The descriptor for [id], or `null` if no enabled module has that id.
  ModuleDescriptor? find(String id) {
    for (final module in modules) {
      if (module.id == id) return module;
    }
    return null;
  }
}
