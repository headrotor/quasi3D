
inside = false;  // true for inside (opaque) slices, 
diam = 3.5; // for output in inches; scale is diam/imsize
shrink = 0.9; // scale inside smaller 
height = 0.25; // height in inches
bthick = 0.075; // thickness of bottom cap




if (inside){ //opaque inside features
    //fillet_disk(diam,height);
    inside_features(diam,height,shrink);
} else if (true){ //transparent outside
    difference(convexity=25) {
    #fillet_disk2(diam,height,bthick);
    inside_features(diam,height,shrink);
    }
}

module inside_features(diam, height, shrink){
  intersection(convexity=2) {
                                              
     fillet_disk2(shrink*diam,shrink*height,0); 
        shave_bottom_sculpt(diam, height,0.7);
        //... oops, crashy crashy
	     //translate([0,0.01])
        //shave_bottom_sculpt(diam, -height,0.7);
    }
}



// load surface image and scale,
module sculpt_surface(width, height) {
    pixsize = 400;
    translate([0, 0, height])
    scale([2*width/pixsize, 2*width/pixsize, -height/100]) 
    //surface(file = "Z58-13cos.png",convexity=25, center=true);
     surface(file = "Z55-7cos400.png",convexity=10, center=true);
}

// shave a fraction off top & bottom
module shave_bottom_sculpt(width, height, fraction){
    // make slice to extract from center of sculpt mesh
    difference(convexity=25){
       
        translate([0,0, height/2])
        scale([2*width, 2*width, height])
        cube(1, center = true);
       // stretch surface so we snip out center
       //translate([0, 0, 0 -fraction*height])
       
       translate([0, 0,  -(1/fraction -1)*height])
       //scale([1,1,height*(1+ fraction)]) 
       sculpt_surface(width, height*(1/fraction));
       
    }
}

// make 1/2 filleted disk: this is the outside transparent part
module fillet_disk2(diam, height1, height2) {
    dheight = 2*height1;
    dheight2 = 2*height2;
    // double height because we are chopping in half    
    rotate_extrude($fn = 200, convexity=25, center=true) {
        difference() {
            hull($fn=200) { 
                // center square axis
                translate([1/2, 0])
                scale([1, dheight])
                square(1, center = true);
                // fillet disk at edge
                translate([diam - dheight/2, 0])
                circle(d=dheight, $fn = 72.0, center=true);
            }
        translate([0,-dheight,0])
        scale([diam,dheight,1])
        square(1);
        }   
	if (height2 > 0) {
        difference() {
            hull($fn=200) { 
                // center square axis
                translate([1/2, 0])
                scale([1, dheight2])
                square(1, center = true);
                // fillet disk at edge
                translate([diam - dheight2/2, 0])
                circle(d=dheight2, $fn = 72.0, center=true);
            }
        translate([0,dheight2,0])
        scale([diam,dheight2,1])
        square(1);
        }   
	}
    }
}

module extend_fillet_disk(diam, height) {
    fillet_disk(diam,height);
   
    fillet_disk(diam,-0.2*height);
}

