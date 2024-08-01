module mccc;
import std::io;
import raylib;
import voxel;

const int CHUNK_SIZE    = 16; 
const int SCREEN_WIDTH  = 800;
const int SCREEN_HEIGHT = 600;

fn void draw_skybox(int gridSize, float spacing) {
    for (int i = -gridSize; i <= gridSize; i++) {
        float a = i * spacing;
        float b = gridSize * spacing;
        raylib::draw_line_3d({ a, -b, 0.0 }, { a, b, 0.0 }, raylib::LIGHTGRAY);
        raylib::draw_line_3d({ -b, a, 0.0 }, { b, a, 0.0 }, raylib::LIGHTGRAY);
        raylib::draw_line_3d({ a, 0.0, -b }, { a, 0.0, b }, raylib::LIGHTGRAY);
        raylib::draw_line_3d({ -b, 0.0, a }, { b, 0.0, a }, raylib::LIGHTGRAY);
        raylib::draw_line_3d({ 0.0, a, -b }, { 0.0, a, b }, raylib::LIGHTGRAY);
        raylib::draw_line_3d({ 0.0, -b, a }, { 0-0, b, a }, raylib::LIGHTGRAY);
    }
}

fn int main(String[] args)
{
	// Initialization
    //--------------------------------------------------------------------------------------
   
    raylib::init_window(SCREEN_WIDTH, SCREEN_HEIGHT, "raylib - voxel batch rendering example");
    defer raylib::close_window();

    raylib::Camera camera;
    camera.position = {20.0, 20.0, 20.0 };
    camera.target = { 0.0, 0.0, 0.0 };
    camera.up = { 0.0, 1.0, 0.0 };    
    camera.fovy = 80.0;
    camera.projection = raylib::CAMERA_PERSPECTIVE;
    // camera.type = raylib::CAMERA_PERSPECTIVE;

    // raylib::set_camera_mode(camera, raylib::CAMERA_FREE);

    raylib::set_target_fps(60);
    raylib::set_trace_log_level(LOG_ALL);
    raylib::disable_cursor();

    // Define a simple voxel chunk
    voxel::Voxel[CHUNK_SIZE * CHUNK_SIZE * CHUNK_SIZE] voxels;
    int voxelCount = 0;

    for (int x = 0; x < CHUNK_SIZE; x++) {
        for (int y = 0; y < CHUNK_SIZE; y++) {
            for (int z = 0; z < CHUNK_SIZE; z++) {
                if (y < CHUNK_SIZE / 2) {
                    voxels[voxelCount].position = { x, y, z };
                    voxels[voxelCount].color = raylib::GREEN;
                    voxelCount++;
                }
            }
        }
    }
    io::print(voxels[1].position);
    io::print("  ");
    io::printn(voxels[1].color);

    Mesh voxelMesh = voxel::generate_voxel_mesh(&voxels, voxelCount);
    Model voxelModel = raylib::load_model_from_mesh(voxelMesh);
    defer raylib::unload_model(voxelModel);

    // Main game loop
    raylib::@game_loop() {
        // Update
        //----------------------------------------------------------------------------------
        raylib::update_camera(&camera, CAMERA_FREE);

        // Draw
        //----------------------------------------------------------------------------------
        raylib::@draw() {
            raylib::clear_background(raylib::RAYWHITE);

            raylib::@mode_3d(camera) {
                // Draw a grid on the ground to visualize movement
                // raylib::draw_grid(20, 1.0);

                raylib::draw_model(voxelModel, {0, 0, 0}, 1.0, raylib::RAYWHITE);
                draw_skybox(20, 1.0);
            };
            raylib::draw_text("Move the camera with keys and mouse", 10, 10, 20, raylib::DARKGRAY);
        }; 
    };

    return 0;
}
