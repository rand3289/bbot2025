// BrakerBot Apr 2025 toandrey(at)yahoo.com
// Uses 1/2" pvc pipe, 608 bearings, 95mm disks from Hard Drives, HS300 servos
// Outer diameter of the 608 bearing is 22mm
// Outer diameter of the 1/2" pvc pipe is 21.3mm

use <bcstr.scad>
include <BOSL2/std.scad>
include <BOSL2/gears.scad>
$fn=128; // make cylinders a bit rounder
w = 50; // outer frame width
l = 57; // outer frame length
h = 16; // frame height

module flatten(){ // remove everything below h/2
    intersection(){
        children();
        t(0,0,h/2) b(200,200,2*h);
//        b(200,200,h); // flatten both sides
    }
}

module cframe(width){
    difference(){
        t(0,l/2,0) b(width,l,h);
        b(width-16,(l-8)*2,h+1);
    }
}

module frame(){
    d = 33;
    difference(){
        union(){
            cframe(w);
            t(29,0,0)  r(0,90,0) c(24,25); // bearing block
            t(-d,0,0) r(0,90,0) c(32,25);  // bearing block
        }
        t(d,0,0)  r(0,90,0) c(29,21.5);  // pipe hole
        t(22.5,0,0)  r(0,90,0) c(8,22);  // bearing hole

        t(-d,0,0) r(0,90,0) c(29,22);  // bearing hole
        t(5,0,0)  r(0,90,0) c(100,11); // shaft hole
        t(8,0,0)  r(90,0,0) c(200,3);  // bracket screw hole
        t(-8,0,0) r(90,0,0) c(200,3);  // bracket screw hole
        t(37,0,13.3) c(4,3);           // vertical screw hole in bearing block
        t(37,0,0) r(90,0,0) c(100,3);  // horisontal screw hole in bearing block
    }
}

module hingeBridge(){
    d = w/2+4;
    difference(){
        union(){
            b(w,8,16);    // beam
            b(w+16,5,10); // attachment points on both sides
            flatten() t(0,12,0) r(90,0,0) c(32,25); // bearing block
        }
        t(0,8.5,0)  r(90,0,0)  c(36,21.5); // pipe hole
        t(0,22.5,0) r(90,0,0)  c(8,22);    // bearing hole
        r(90,0,0)   c(100,11);             // shaft hole
        t(d,0,0)    r(90,0,0)  c(16,3);    // screw hole
        t(-d,0,0)   r(90,0,0)  c(16,3);    // screw hole
        t(0,0,13.3) c(4,3);                // screw hole in bearing block. 13.3 for "print support"
        t(0,15,0)   r(0,70,0)  c(30,3);    // screw hole in bearing block
        t(0,15,0)   r(0,-70,0) c(30,3);    // screw hole in bearing block
    }
}

module hingeBridgeSupported(){ // supported for 3D printing
    hingeBridge();
    t(32,0,-6.5)  sq_pipe(2,5,3,0.3); //  print support
    t(-32,0,-6.5) sq_pipe(2,5,3,0.3); //  print support
}

module hingeSide(){
    difference(){
        union(){
            r(0,90,0) c(8,28.3);    // pipe
            t(0,l/2,0) b(8,l+4,h); // side
        }
        r(0,90,0) c(w+18,25.3);     // hinge hole
        t(0,l-4,0) b(12,5.2,10.2);  // bridge hole with tolerance added
        t(0,l,0) r(90,0,0) c(30,3); // screw hole
    }
}

module hingeAssembly(){ // for visualization
    d = w/2+4;
    color("yellow") t(d,0,0)  r(180,0,0) hingeSide();
    color("yellow") t(-d,0,0) r(180,0,0) hingeSide();
    t(0,-(l-4),0) hingeBridge();
}

module leg(){
    difference(){
        union(){
            b(26,8,h);
            t(0,6,0) r(90,0,0) c(20,25);
        }
        t(0,9,0)  r(90,0,0) c(20,21.5); // pipe mounting hole
        t(0,10,0) r(0,90,0) c(30,3);    // pipe screw hole
        t(0,10,0)           c(30,3);    // pipe screw hole
        t(8,0,0)  r(90,0,0) c(20,3);    // leg attachment screw hole
        t(-8,0,0) r(90,0,0) c(20,3);    // leg attachment screw hole
    }
}

module cap(){
    difference(){
        c(16, 28);                   // cap body
        t(0,0,1.5) c(16,22);         // bearing hole
        t(0,0,8.5) c(16,25);       // slides over bearing block
        t(0,0,4)  r(0,90,0) c(30,3); // screw hole
        t(0,0,4)  r(90,0,0) c(30,3); // screw hole
        t(5,0,0)  c(20,2);           // bottom hole to help take out the bearing
        t(-5,0,0) c(20,2);           // bottom hole
    }
}

// differential gear with a square shaft hole
module dgear(){
    disk_od = 95;
    disk_id = 25;
    disk_h  = 1.25;
    gteeth  = 20;
    shaft_round = 8; // 608 bearings fit an 8mm round shaft
    // if you grind an end of a round shaft into a square, it will be this size
    shaft_square = sqrt(shaft_round*shaft_round/2);
    shaft_hole = shaft_square + 0.3;
    echo("Shaft end square size", shaft_square);

    difference(){
        union(){
            t(0,0,1.3258) bevel_gear(teeth=gteeth, mate_teeth=gteeth, mod=1.5, cutter_radius=0, spiral=0, shaft_diam=1);
            color("red") t(0,0,-disk_h/2) c(disk_h, disk_id); // base for mounting a brake disk
        } // I don't know why the gear is 1.4 below z=0
        b(shaft_hole,shaft_hole,20);
    }
}


if($preview){
    t(120,0,0) r(90,90,0) flatten() frame();
    t(120,0,0) r(90,90,0) hingeAssembly();
    flatten() frame();
    hingeAssembly();
    t(0,-150,0) r(0,0,180) flatten() frame();
    t(0,-150,0) r(0,0,180) hingeAssembly();

    t(-60, -150, 0) r(0,90,0) cap();
    t(0,-220,0) r(180,0,0) leg();
%   t(0,-320,0) rx() c(200,21.5);   // leg pvc pipe / visual aid
%   t(0,-75,0)r(90,0,0) c(83,21.5); // pvc pipe / visual aid
    dgear();
} else { // rendering for 3D printing
    flatten() frame();
    t(-70,-40,0) cap();
    t(70,40,0) r(180,90,0) hingeSide();
    t(100,-40,0) r(0,90,90) hingeSide(); // need two printed
    t(0,-50,0) hingeBridgeSupported();
    t(80,80,0) dgear();
    t(40,80,0) dgear();
    t(0,80,0) dgear();
}
