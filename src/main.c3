module mccc;
import std::io;
import raylib;
import voxel;

const int CHUNK_SIZE    = 16; 
const int SCREEN_WIDTH  = 800;
const int SCREEN_HEIGHT = 600;

fn int main(String[] args)
{
	// Initialization
    //--------------------------------------------------------------------------------------
    
    raylib::init_window(SCREEN_WIDTH, SCREEN_HEIGHT, "raylib - voxel batch rendering example");

    raylib::Camera3D camera;
    camera.position = {20.0, 20.0, 20.0 };
    camera.target = { 0.0, 0.0, 0.0 };
    camera.up = { 0.0, 1.0, 0.0 };
    camera.fovy = 45.0;
    // camera.type = raylib::CAMERA_PERSPECTIVE;

    // raylib::set_camera_mode(camera, raylib::CAMERA_FREE);

    raylib::set_target_fps(60);

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

    Mesh voxelMesh = voxel::generate_voxel_mesh(&voxels, voxelCount);
    Model voxelModel = raylib::load_model_from_mesh(voxelMesh);

    // Main game loop
    while (!raylib::window_should_close()) {
        // Update
        //----------------------------------------------------------------------------------
        raylib::update_camera(&camera, raylib::CAMERA_FREE);

        // Draw
        //----------------------------------------------------------------------------------
        raylib::begin_drawing(); {
            raylib::clear_background(raylib::RAYWHITE);

            raylib::begin_mode_3D(camera); {
                raylib::draw_model(voxelModel, {0, 0, 0}, 1.0, raylib::WHITE);
            } raylib::end_mode_3D();
            raylib::draw_text("Move the camera with keys and mouse", 10, 10, 20, raylib::DARKGRAY);
        } raylib::end_drawing();
    }

    // De-Initialization
    raylib::unload_model(voxelModel);
    raylib::close_window();

    return 0;
}
