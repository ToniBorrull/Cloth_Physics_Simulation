//Voxels + Cloth

//Particles Varibles
int w = 10;
int h = 10;
Particle[][] cloth;
Particle p;
//Voxel
voxel v;

void setup() {
  size(500, 500, P3D);
  //int posX, int posY, int posZ, float dx, float dy, float dz, float px, float py, float pz, color c
  v = new voxel(width/2, height/2, 0, 100, 100, 100, -5, 0, 0, color(200));
  p = new Particle(new PVector(100, 100, 100), true);
  cloth = new Particle[h][w];
  //Generate the particles
  for (int i = 0; i < h; i++) {
    for (int j = 0; j < w; j++) {
      if ((i == 0 && j == 0) || (i == 0 && j == (w - 1))) {
        cloth[i][j] = new Particle(new PVector(100, 100, 100), true);
      } else {
        cloth[i][j] = new Particle(new PVector(300, 300, 300));
      }
    }
  }
}

void draw() {
  background(255);
  v.Draw();
  for (int i = 0; i < h; i++) {
    for (int j = 0; j < w; j++) {
        cloth[i][j].ParticleMove();
        cloth[i][j].Draw();
    }
  }
}
