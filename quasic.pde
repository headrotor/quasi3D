
int imsize =400;
// true for cosine,  false for sine
Boolean even = false; 

// select operation by uncommenting
void setup() {
  
  
  //print_gallery(); // plot a gallery of different numbers and freqencies
  //print_zgallery(5); // as above but with striped palette

  //print_one(5,9);  // print one quasicrystal with 5 waves at freq 9

  // print one striped quasicrystal with 5 waves of freq 6.5 and 5-stripe palette
  print_zebra(5, 6.5, 5); 
}

Boolean saved =false;
void draw(){

  
  if(!saved){
    saveFrame("gallery.png"); 
    print("saved");
  }
  saved = true;
}

// map image with striped palette
void print_zebra(int nwaves, float nfreq, float zfreq) {
  size(imsize, imsize);  
  PImage img0 = image_wave(nwaves, nfreq);
  PImage img = sinezebra(img0,zfreq);
  String type;
  if (even) 
    type = "cos";
  else
    type = "sin";

  String fname = "Z5" + str(nwaves)+"-"+str(int(nfreq))+type+"400.png";

  image(img, 0, 0);
  img.save(fname); 
  if (even) { // sin is its own inverse, no need to compute
    fname = "Z5" + str(nwaves)+"-"+str(int(nfreq))+type+"-inv.png";
    img.filter(INVERT);
    img.save(fname);
  }
}  

// print one quasicrystal with nwaves radial waves at freq nfreq
void print_one(int nwaves, float nfreq) {
  size(imsize, imsize);  
  PImage img = image_wave(nwaves, nfreq);
  String type;
  if (even) 
    type = "cos";
  else
    type = "sin";

  String fname = str(nwaves)+"-"+str(int(nfreq))+type+".png";

  image(img, 0, 0);
  img.save(fname); 
  if (even) { // sin is its own inverse, no need to compute
    fname = str(nwaves)+"-"+str(int(nfreq))+type+"-inv.png";
    img.filter(INVERT);
    img.save(fname);
  }
}

void print_gallery() {
  imsize = 65;
  size(800, 800);  
  int i, j;
  fill(0);
  textSize(18);
  for (i=1; i < 10; i++) {
    for (j=1; j < 10; j++) {
      PImage img = image_wave(i, j);
      //PImage imgz = zebra(img,5);
      image(img, i*(imsize +5), j*(imsize + 5));
      if (i == 9)
        text("f=" + str(j), (i+1)*(imsize +5), (j)*(imsize + 5) +30);
    }
    text("n=" + str(i), (i)*(imsize +5) +10, (j)*(imsize + 5) +10);
  }
}

void print_zgallery(float freq) {
  imsize = 101;
  size(1000, 1000);  
  int i, j;

  fill(0);
  textSize(18);
  for (i=0; i < 9; i++) {
    for (j=0; j < 9; j++) {
      
      PImage img0 = image_wave(i+1, freq);
      PImage img = sinezebra(img0,j+1);
      //PImage imgz = zebra(img,5);
      image(img, i*(imsize +5), j*(imsize + 5));
      if (i == 8)
        text("w=" + str(j+1), (i+1)*(imsize +5), (j)*(imsize + 5) +30);
    }
    text("n=" + str(i+1), (i)*(imsize +5) +10, (j)*(imsize + 5) +10);
  }
}

PImage zebra(PImage p, int levels) {
  // transform gray level image to have black/white stripes
  int modu = int(255.0/float(levels)); 
  PImage result = p;
  result.filter(GRAY);
  result.loadPixels();
  for (int i = 0; i < p.width * p.height; i ++) { 
    float v = red(result.pixels[i]);
    int v2 = int(v/ modu);
    if ((v2 % 2) == 0) 
      result.pixels[i] = color(255, 255, 255); 
    else
      result.pixels[i] = color(0, 0, 0);
  } 
  result.updatePixels();
  return result;
}

PImage sinezebra(PImage p, float freq) {
  // transform gray level image to have black/white stripes
  PImage result = p;
  result.filter(GRAY);
  result.loadPixels();
  for (int i = 0; i < p.width * p.height; i ++) { 
    float v = red(result.pixels[i]);
    float sinv = sin(TWO_PI*freq*v/(255.0 ));
    int v2 = int(map(sinv,-1,1,0,255));
    result.pixels[i] = color(v2, v2, v2);
  } 
  result.updatePixels();
  return result;
}

PImage image_wave(int nwaves, float freq) {
  float[] wfreq = new float[nwaves];
  float[] wangle = new float[nwaves];
  int n;


  for (n = 0; n < nwaves; n++) {
    wangle[n] = (n + 0.5)*180.0/float(nwaves);
    wfreq[n] = freq;
  }

  int w2 = int((imsize -1)/2);

  PImage img = createImage(imsize, imsize, RGB);
  for (int i = -w2; i <= w2; i++) {
    for (int j = -w2; j <= w2; j++) {

      float a =0;
      for (n = 0; n < nwaves; n++) {

        a += wave(i, j, wfreq[n], wangle[n]);
      }

      int v = int(map(a/nwaves, -1, 1, 255, 0));
      img.set(i + w2, j + w2, color(v, v, v));
    }
  }
  return img;
}

float wave(int i, int j, float freq, float angle) {
  float x, y;
  // calculate phase in driection of angle
  x = TWO_PI*freq*i*sin(TWO_PI*angle/360.0)/float(imsize);
  y = TWO_PI*freq*j*cos(TWO_PI*angle/360.0)/float(imsize);
  // change to cosine for even symmetry
  if (even)
    return  cos(x + y);
  else
    return  sin(x + y);
}

