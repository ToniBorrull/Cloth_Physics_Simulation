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

//Player
Player player;

float subcalcs = 99;

void setup() {
  size(900, 900, P3D);
  //int posX, int posY, int posZ, float dx, float dy, float dz, float px, float py, float pz, color c
  v = new voxel(width/2, 550, 0, 200, 100, 200, 0, 0, 0, color(200));
  frameRate(240);
  cols = 100;
  rows = 1;
  depth = cols;

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
          cloth[i][j][k] = new Particle(new PVector(i * particleXDist, height / 2, -k * particleZDist), true);
        } else {
          cloth[i][j][k] = new Particle(new PVector(i * particleXDist, height / 2 + j * particleYDist, -k * particleZDist));
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

  //Player
  player = new Player(new PVector(width/2, -70, -width/2), 5, 70);
}

void draw() {
  background(255);
  push();
  translate(width/2, height / 2, -camZ);
  rotateX(angleX);
  rotateY(angleY);

  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      for (int k = 0; k < depth; k++) {
        cloth[i][j][k].ResetForces();
      }
    }
  }

  player.ResetForces();

  for (Spring s : springs) {
    s.ApplySpringAB();
    s.ApplySpringBA();
    s.Draw();
  }

  player.DrawPlayer();

  //Draw the Voxel
  //v.Draw();
  for (int s = 0; s < subcalcs; s++)
  {

    for (int i = 0; i <cols; i++) {
      for (int j = 0; j < rows; j++) {
        for (int k = 0; k < depth; k++) {
          if (isInside(cloth[i][j][k], player)) {
            PVector movePlayer = new PVector(cloth[i][j][k].pos.x - player.position.x, cloth[i][j][k].pos.y - player.position.y, cloth[i][j][k].pos.z - player.position.z);
            //if (movePlayer.x != 0 && movePlayer.y != 0 && movePlayer.z != 0) movePlayer = normalizeVector(movePlayer);

            cloth[i][j][k].pForce.x += movePlayer.x / 50;
            cloth[i][j][k].pForce.y += movePlayer.y / 50;
            cloth[i][j][k].pForce.z += movePlayer.z / 50;

            player.force.x -= movePlayer.x / 50;
            player.force.y -= movePlayer.y / 50;
            player.force.z -= movePlayer.z / 50;

            cloth[i][j][k].Draw();
          }

          cloth[i][j][k].ParticleMove();
        }
      }
    }
    player.MovePlayer();
    player.ResetForces();
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

  if (keyCode == SHIFT) player.position.y -= gravityPlayer + 50;

  if (key == 'i') player.position.z -= 10;
  if (key == 'j') player.position.x -= 10;
  if (key == 'k') player.position.z += 10;
  if (key == 'l') player.position.x += 10;

  player.MovePlayer();

  if (key == 'p')
  {
    cloth[0][0][0].pos.x -= 0.5;
    cloth[0][0][0].pos.z += 0.5;

    for (int k = 1; k < depth - 1; k++) {
      cloth[0][0][k].pos.x = cloth[0][0][0].pos.x;
    }

    cloth[0][0][depth-1].pos.x -= 0.5;
    cloth[0][0][depth-1].pos.z -= 0.5;

    for (int i = 1; i < cols - 1; i++) {
      cloth[i][0][depth-1].pos.z = cloth[0][0][depth-1].pos.z;
    }

    cloth[cols-1][0][0].pos.x += 0.5;
    cloth[cols-1][0][0].pos.z += 0.5;

    for (int i = 1; i < cols - 1; i++) {
      cloth[i][0][0].pos.z = cloth[cols-1][0][0].pos.z;
    }

    cloth[cols-1][0][depth-1].pos.x += 0.5;
    cloth[cols-1][0][depth-1].pos.z -= 0.5;

    for (int k = 1; k < depth - 1; k++) {
      cloth[cols-1][0][k].pos.x = cloth[cols-1][0][depth-1].pos.x;
    }
  }
  MoveCamera();
  //v.MoveVoxel();
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
