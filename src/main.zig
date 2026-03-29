const rl = @import("raylib");

pub fn main() anyerror!void {
    // Initialisation de la fenêtre
    const screen_width = 800;
    const screen_height = 450;

    rl.initWindow(screen_width, screen_height, "Zig & Raylib - Premier Triangle");
    defer rl.closeWindow(); // Fermeture propre à la fin du programme

    rl.setTargetFPS(60);

    while (!rl.windowShouldClose()) {
        // Début du rendu
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.ray_white);

        // Dessiner le triangle
        // Paramètres : Sommet haut, Bas gauche, Bas droite, Couleur
        rl.drawTriangle(
            .{ .x = screen_width / 2, .y = 80 },
            .{ .x = screen_width / 2 - 120, .y = 300 },
            .{ .x = screen_width / 2 + 120, .y = 300 },
            rl.Color.red,
        );

        rl.drawText("Bravo ! Un triangle en Zig.", 190, 350, 20, rl.Color.dark_gray);
    }
}
