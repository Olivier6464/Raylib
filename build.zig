const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // 1. Création de ton module principal
    const app_module = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    // 2. Création de l'exécutable
    const exe = b.addExecutable(.{
        .name = "mon-triangle",
        .root_module = app_module,
        // Ajoute cette ligne pour masquer la console sur Windows :
        // .subsystem = .Windows,
    });

    // 3. Appel de la dépendance locale définie dans ton .zon
    // On passe exactement 2 arguments : le nom et les options
    const raylib_dep = b.dependency("raylib", .{
        .target = target,
        .optimize = optimize,
    });
    // 4. Import du module raylib (via le fichier source directement)
    // On crée notre propre module à partir du fichier source de la dépendance
    const raylib_module = b.createModule(.{
        .root_source_file = raylib_dep.path("lib/raylib.zig"),
        .target = target,
        .optimize = optimize,
    });

    // 4. Import du module raylib et lien avec la bibliothèque
    // On l'ajoute à ton application
    app_module.addImport("raylib", raylib_module);

    // On lie le binaire compilé (l'artifact "raylib")
    exe.root_module.linkLibrary(raylib_dep.artifact("raylib"));
    // 5. Installation dans zig-out/bin
    b.installArtifact(exe);

    // 6. Configuration de la commande run
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Lancer l'application");
    run_step.dependOn(&run_cmd.step);
}
