//Voxels + Cloth //<>//

//Particles Varibles
int cols;
int rows;
Particle[][] cloth;
ArrayList<Spring> springs = new ArrayList<Spring>();

int allPoints;

PVector[] screenPoints;
int draggedPoint = -1; //-1 if nothing is being dragged

float particleXDist, particleYDist;
float camZ = width;

//Voxel
voxel v;

float angleX = 0, angleY = 0;

float speed = 20;

void setup() {
  size(500, 500, P3D);
  //int posX, int posY, int posZ, float dx, float dy, float dz, float px, float py, float pz, color c
  v = new voxel(width/2, 550, 0, 200, 100, 200, 0, -100, 50, color(200));

  cols = 25;
  rows = 25;
  allPoints = cols * rows;

  particleXDist = 10;
  particleYDist = 10;

  cloth = new Particle[cols][rows];

  screenPoints = new PVector[allPoints];
  for (int i = 0; i < screenPoints.length; i++) {
    screenPoints[i] = new PVector(0, 0);
  }

  //Generate the particles
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      if (j == 0 && (i == 0 || i == cols - 1)) {
        cloth[i][j] = new Particle(new PVector(i * particleXDist, 0, 0), true);
      } else {
        cloth[i][j] = new Particle(new PVector(i * particleXDist, j * particleYDist, 0));
      }
    }
  }

  float dureza = 0.8;
  float restLength;

  if (particleXDist > particleYDist) restLength = particleYDist;
  else restLength = particleXDist;

  //Apply String to each particle
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      if (i < cols - 1) {
        //PVector _p1, PVector _p2, float _KS, float _rl, float _maxDisplacement
        springs.add(new Spring(cloth[i][j], cloth[i + 1][j], dureza, restLength));
      }

      if (j < rows - 1) {
        //PVector _p1, PVector _p2, float _KS, float _rl, float _maxDisplacement
        springs.add(new Spring(cloth[i][j], cloth[i][j + 1], dureza, restLength));
      }
    }
  }
}

void draw() {
  background(255);
  push();
  translate(width/2, height/2, -camZ);
  rotateX(angleX);
  rotateY(angleY);

  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      cloth[i][j].ResetForces();
    }
  }

  for (Spring s : springs) {
    s.ApplySpringAB();
    s.ApplySpringBA();
    s.Draw();
  }

  //Draw the Voxel
  v.Draw();

  for (int i = 0; i <cols; i++) {
    for (int j = 0; j < rows; j++) {
      if (isInside(cloth[i][j], v)) {
        cloth[i][j].pForce.x += v.property_voxel.x;
        cloth[i][j].pForce.y += v.property_voxel.y;
        cloth[i][j].pForce.z += v.property_voxel.z;
        cloth[i][j].col = color(0, 0, 255);
      } else cloth[i][j].col = color(255, 0, 0);

      cloth[i][j].ParticleMove();
      cloth[i][j].Draw();
    }
  }
  pop();
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      PVector p = cloth[i][j].pos;

      int index = i + j * cols;
      screenPoints[index].x = screenX(p.x, p.y, -camZ);
      screenPoints[index].y = screenY(p.x, p.y, -camZ);
    }
  }

  MoveCamera();
  v.MoveVoxel();
}

void MoveCamera() {
  println(angleY);
  if (keyCode == UP) angleX -= radians(1);
  if (keyCode == DOWN) angleX += radians(1);
  if (keyCode == RIGHT) angleY -= radians(1);
  if (keyCode == LEFT) angleY += radians(1);
}

void keyPressed() {
  if (key == 'w' || key == 'W') goesUp = true;
  if (key == 's' || key == 'S') goesDown = true;
  if (key == 'a' || key == 'A') goesLeft = true;
  if (key == 'd' || key == 'D') goesRight = true;
}
void keyReleased()
{
  if (key == 'w' || key == 'W') goesUp = false;
  if (key == 's' || key == 'S') goesDown = false;
  if (key == 'a' || key == 'A') goesLeft = false;
  if (key == 'd' || key == 'D') goesRight = false;
  keyCode = 0;
  key = 0;
}

void mousePressed()
{


  //reset the draggedPoint
  draggedPoint = -1;

  //If the mouse is in-bounds of the screenPoint, mark it as the actual control point to move
  for (int i = 0; i < allPoints; i++) {
      
    if (dist(mouseX, mouseY, screenX(screenPoints[i].x, screenPoints[i].y, screenPoints[i].z), screenY(screenPoints[i].x, screenPoints[i].y, screenPoints[i].z)) < 20) {
      draggedPoint = i;
      break;
    }
  }
}

void mouseDragged() {
  //If there is a point selected
  if (draggedPoint != -1) {
    int i = draggedPoint % cols;
    int j = draggedPoint / cols;

    //Move it x and z based on the mouse pos
    cloth[i][j].pos.x += (mouseX - pmouseX);
    cloth[i][j].pos.y += (mouseY - pmouseY);
  }
}

void mouseReleased()
{


  draggedPoint = -1;
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if (e < 0) camZ -= 25;
  if (e > 0) camZ += 25;
}
