module voxel;
import raylib;

struct Voxel {
    Vector3 position;
    Color color;
}

// Function to create a mesh from voxels
fn raylib::Mesh generate_voxel_mesh(Voxel *voxels, int voxelCount) {
    int verticesCount = voxelCount * 36; // 6 faces * 2 triangles * 3 vertices
    float *vertices = malloc((long)verticesCount * 3 * float.sizeof);
    float *normals = malloc((long)verticesCount * 3 * float.sizeof);
    float *texcoords = malloc((long)verticesCount * 2 * char.sizeof);
    char *colors = malloc((long)verticesCount * 4 * char.sizeof);

    int vertexIndex = 0;

    for (int i = 0; i < voxelCount; i++) {
        Voxel voxel = voxels[i];

        int[3] x = { 1, 2, 3 };

        Vector3[36] cubeVertices;

        int iota = 0;

        cubeVertices[iota++] = { voxel.position.x - 0.5, voxel.position.y - 0.5, voxel.position.z - 0.5 };
        cubeVertices[iota++] = { voxel.position.x + 0.5, voxel.position.y - 0.5, voxel.position.z - 0.5 };
        cubeVertices[iota++] = { voxel.position.x + 0.5, voxel.position.y + 0.5, voxel.position.z - 0.5 };
        cubeVertices[iota++] = { voxel.position.x - 0.5, voxel.position.y - 0.5, voxel.position.z - 0.5 };
        cubeVertices[iota++] = { voxel.position.x + 0.5, voxel.position.y + 0.5, voxel.position.z - 0.5 };
        cubeVertices[iota++] = { voxel.position.x - 0.5, voxel.position.y + 0.5, voxel.position.z - 0.5 };
       
        iota = 0;

        Vector3[36] cubeNormals;
        // Define the normals for each face
        // Front face
        cubeNormals[iota++] = { 0.0, 0.0, -1.0 };
        cubeNormals[iota++] = { 0.0, 0.0, -1.0 };
        cubeNormals[iota++] = { 0.0, 0.0, -1.0 };
        cubeNormals[iota++] = { 0.0, 0.0, -1.0 };
        cubeNormals[iota++] = { 0.0, 0.0, -1.0 };
        cubeNormals[iota++] = { 0.0, 0.0, -1.0 };
        // Define other faces similarly...

        iota = 0;

        // Copy data to arrays
        for (int j = 0; j < 36; j++) {
            vertices[vertexIndex * 3] = cubeVertices[j].x;
            vertices[vertexIndex * 3 + 1] = cubeVertices[j].y;
            vertices[vertexIndex * 3 + 2] = cubeVertices[j].z;

            normals[vertexIndex * 3] = cubeNormals[j].x;
            normals[vertexIndex * 3 + 1] = cubeNormals[j].y;
            normals[vertexIndex * 3 + 2] = cubeNormals[j].z;

            texcoords[vertexIndex * 2] = (j % 6 < 3) ? 0.0 : 1.0; // Example texcoords
            texcoords[vertexIndex * 2 + 1] = (j % 3 == 0) ? 0.0 : 1.0;

            colors[vertexIndex * 4] = voxel.color.r;
            colors[vertexIndex * 4 + 1] = voxel.color.g;
            colors[vertexIndex * 4 + 2] = voxel.color.b;
            colors[vertexIndex * 4 + 3] = voxel.color.a;

            vertexIndex++;
        }
    }

    Mesh mesh;
    mesh.vertexCount = verticesCount;
    mesh.triangleCount = verticesCount / 3;

    mesh.vertices = vertices;
    mesh.normals = normals;
    mesh.texcoords = texcoords;
    mesh.colors = colors;

    raylib::upload_mesh(&mesh, true);

    return mesh;
}
