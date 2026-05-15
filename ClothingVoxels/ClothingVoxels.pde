//Voxels + Cloth //<>// //<>//

//Particles Varibles
int cols;
int rows;
int depth;
Particle[][][] cloth;
ArrayList<Spring> springs = new ArrayList<Spring>();

int allPoints;

PVector[] screenPoints;
int draggedPoint = -1; //-1 if nothing is being dragged

float particleXDist, particleYDist, particleZDist;
float camZ = width;

//Voxel
voxel v;

float angleX = 0, angleY = 0;

float speed = 20;

void setup() {
  size(500, 500, P3D);
  //int posX, int posY, int posZ, float dx, float dy, float dz, float px, float py, float pz, color c
  v = new voxel(width/2, 550, 0, 200, 100, 200, 0, -100, 50, color(200));
  frameRate(240);
  cols = 20;
  rows = 1;
  depth = 20;

  allPoints = cols * rows * depth;

  particleXDist = width / cols;
  particleYDist = height / rows;
  particleZDist = width / depth;

  cloth = new Particle[cols][rows][depth];

  screenPoints = new PVector[allPoints];
  for (int i = 0; i < screenPoints.length; i++) {
    screenPoints[i] = new PVector(0, 0);
  }

  //Generate the particles
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      for (int k = 0; k < depth; k++) {
        if (j == 0 && ((i == 0 || i == cols - 1) && (k == 0 || k == depth - 1))) {
          cloth[i][j][k] = new Particle(new PVector(i * particleXDist, 0, -k * particleZDist), true);
          println(k);
        } else {
          cloth[i][j][k] = new Particle(new PVector(i * particleXDist, j * particleYDist, -k * particleZDist));
        }
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
      for (int k = 0; k < depth; k++) {
        if (i < cols - 1) {
          //PVector _p1, PVector _p2, float _KS, float _rl, float _maxDisplacement
          springs.add(new Spring(cloth[i][j][k], cloth[i + 1][j][k], dureza, restLength));
        }

        if (j < rows - 1) {
          //PVector _p1, PVector _p2, float _KS, float _rl, float _maxDisplacement
          springs.add(new Spring(cloth[i][j][k], cloth[i][j + 1][k], dureza, restLength));
        }

        if (k < depth - 1) {
          //PVector _p1, PVector _p2, float _KS, float _rl, float _maxDisplacement
          springs.add(new Spring(cloth[i][j][k], cloth[i][j][k + 1], dureza, restLength));
        }
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
      for (int k = 0; k < depth; k++) {
        cloth[i][j][k].ResetForces();
      }
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
      for (int k = 0; k < depth; k++) {
        if (isInside(cloth[i][j][k], v)) {
          cloth[i][j][k].pForce.x += v.property_voxel.x;
          cloth[i][j][k].pForce.y += v.property_voxel.y;
          cloth[i][j][k].pForce.z += v.property_voxel.z;
          cloth[i][j][k].col = color(0, 0, 255);
        } else cloth[i][j][k].col = color(255, 0, 0);

        cloth[i][j][k].ParticleMove();
        cloth[i][j][k].Draw();
      }
    }
  }
  pop();
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      for (int k = 0; k < depth; k++) {
        PVector p = cloth[i][j][k].pos;

        int index = i + j * cols;
        screenPoints[index].x = screenX(p.x, p.y, -camZ);
        screenPoints[index].y = screenY(p.x, p.y, -camZ);
      }
    }
  }

  MoveCamera();
  v.MoveVoxel();
}

void MoveCamera() {
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
    int k = draggedPoint % cols;

    //Move it x and z based on the mouse pos
    cloth[i][j][k].pos.x += (mouseX - pmouseX);
    cloth[i][j][k].pos.y += (mouseY - pmouseY);
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
