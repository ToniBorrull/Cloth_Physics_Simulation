//Voxels + Cloth

//Particles Varibles
int w, h = 2;
Particle[][] cloth = new Particle[h][w];

//Voxel
voxel v;


float angleX = 0, angleY = 0;

void setup() {
  size(500, 500, P3D);
  //int posX, int posY, int posZ, float dx, float dy, float dz, float px, float py, float pz, color c
  v = new voxel(width/2, height/2, 0, 100, 100, 100, -5, 0, 0, color(200));

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
  v.render_voxel();

  translate(width/2, height/2, -100);
  rotateX(angleX);
  rotateY(angleY);

  for (int i = 0; i < h; i++) {
    for (int j = 0; j < w; j++) {
      cloth[i][j].Draw();
    }
  }
  
  MoveCamera();
}

void MoveCamera() {
  println(angleY);
  if (keyCode == UP) angleY += radians(1);
  if (keyCode == DOWN) angleY -= radians(1);
  if (keyCode == RIGHT) angleX += radians(1);
  if (keyCode == LEFT) angleX -= radians(1);
}

void keyReleased()
{
  keyCode = 0; 
}
