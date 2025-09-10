// bcstr.scad generic helper modules (2025-04-27)
// comments after modules show up in vscode tooltips
module b(x,y,z){           cube([x,y,z],center=true); }     // block (cube)
module c(hi,od){ $fn=16*sqrt(od); cylinder(h=hi, d=od, center=true); } // cylinder
module s(diameter){        sphere(d=diameter); }            // sphere
module t(x,y,z){           translate([x,y,z]) children(); } // translate
module r(ax,ay,az){        rotate([ax,ay,az]) children(); } // rotate

// rotating around one axis by 90 degrees is very common
module rx(a=90){ rotate([a,0,0]) children(); }
module ry(a=90){ rotate([0,a,0]) children(); }
module rz(a=90){ rotate([0,0,a]) children(); }


// capped or regular pipe
// cap parameter is the thickness of a cap
module pipe(len, od, id, cap=0){
    inLen = cap ? len-2*cap : len+2;
    difference(){
        c(len, od);
        c(inLen, id);
    }
}


// capped or regular square pipe (tube)
// wall parameter is wall thickness
// cap parameter is the thickness of a cap
module sq_pipe(length, width, height, wall, cap=0){
    h = cap ? height-2*cap : height+2;
    difference(){
        b(length, width, height);
        b(length-2*wall, width-2*wall, h);
    }
}


// this allows you to make C-channels and open boxes
// parameters are the same as for sq_pipe()
module open_sqp(length, width, height, wall, cap=0){
    dt = 0.02; // overlaps for the cutout
    difference() { // opens one wall
        sq_pipe(length, width, height, wall, cap);
        t(0,(width-wall)/2,0) b(length-2*wall,wall+dt,dt+height-2*cap);
    }
}


// tests
color("red") s(100);
c(100,50);
b(100,100,50);
color("grey") t(100,0,0)  pipe(50,20,10);
t(0,-100,0) sq_pipe(40,20,50,3);
color("orange") t(0,100,0) open_sqp(40,20,50,3);
t(0,150,0) open_sqp(40,20,50,3,3);

// show how cylinders look with "progressive" $fn
t(100,100,0) c(20,0.3);
t(100,105,0) c(20,0.5);
t(100,110,0) c(20,1);
t(100,115,0) c(20,3);
t(100,120,0) c(20,5);
t(100,130,0) c(20,10);
t(100,150,0) c(20,25);

intersection(){ // capped pipe demo
    t(-100,0,0) pipe(50,20,10,1);
    t(-90,0,0) b(22,22,60); // slice the pipe to show caps
}

