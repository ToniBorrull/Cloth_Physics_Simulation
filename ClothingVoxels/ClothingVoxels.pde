//Voxels + Cloth

//Particles Varibles
int cols = 10;
int rows = 10;
Particle[][] cloth;

//Voxel
voxel v;


float angleX = 0, angleY = 0;

void setup() {
  size(500, 500, P3D);
  //int posX, int posY, int posZ, float dx, float dy, float dz, float px, float py, float pz, color c
  v = new voxel(width/2, height/2, 0, 100, 100, 100, -5, 0, 0, color(200));
  cloth = new Particle[cols][rows];
  //Generate the particles
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      if ((i == 0 && j == 0) || (i == 0 && j == (rows - 1))) {
        cloth[i][j] = new Particle(new PVector(i * 100, 100, 100), true);
      } else {
        cloth[i][j] = new Particle(new PVector(i * 100, 300, 300));
      }
    }
  }
}

void draw() {
  background(255);
  v.Draw();

  
  rotateX(angleX);
  rotateY(angleY);

  for (int i = 0; i <cols; i++) {
    for (int j = 0; j < rows; j++) {
        cloth[i][j].ParticleMove();
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
