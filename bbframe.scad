// BrakerBot2025 toandrey(at)yahoo.com
// Uses 1/2" pvc pipe, 608 bearings, 95mm disks from Hard Drives, HS300 servos
// five 608 bearings are used at every joint
// Outer diameter of the 608 bearing is 22mm
// Outer diameter of the 1/2" pvc pipe is 21.5mm

use <bcstr.scad> // b(),c(),s(),t(),r()
include <BOSL2/std.scad>
include <BOSL2/gears.scad>
$fn=128; // make cylinders a bit rounder
w = 34; // outer frame width
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
            cframe(66);
            t(29,0,0)  r(0,90,0) c(24,25); // bearing block
            t(-d,0,0) r(0,90,0) c(32,25);  // bearing block
        }
        t(d,0,0)  r(0,90,0) c(29,22);  // pipe and bearing hole
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
            flatten() t(0,15,0) r(90,0,0) c(38,25); // bearing block
            t(0,15,-4) b(25,38,8); // makes bearing block square
        }
        t(0,11.5,0) r(90,0,0)  c(42,22);   // pipe and bearing hole
        r(90,0,0)   c(100,11);             // shaft hole
        t(d,0,0)    r(90,0,0)  c(16,3);    // screw hole
        t(-d,0,0)   r(90,0,0)  c(16,3);    // screw hole
        t(0,0,13.3) c(4,3);                // screw hole in bearing block. 13.3 for "print support"
//1        t(-10,20,0) c(30,3);               // brake mounting hole in bearing block
//1        t(10,20,0)  c(30,3);               // brake mounting hole in bearing block
    }
}

module hingeBridgeSupported(){ // supported for 3D printing
    hingeBridge();
    t(24,0,-6.5)  sq_pipe(2,5,3,0.3); //  print support
    t(-24,0,-6.5) sq_pipe(2,5,3,0.3); //  print support
}

module hingeSide(){
    difference(){
        union(){
            r(0,90,0) c(8,28.5);   // pipe
            t(0,l/2,0) b(8,l+4,h); // side
        }
        r(0,90,0) c(10,25.5);       // hinge hole
        t(0,l-4,0) b(12,5.2,10.2);  // bridge hole with tolerance added
        t(0,l,0) r(90,0,0) c(30,3); // screw hole
//1        t(1.5,33,0) c(30,3);        // brake mounting hole
    }
}

module hingeAssembly(){ // for visualization
    d = w/2+4;
    color("yellow") t(d,0,0)  r(180,180,0) hingeSide();
    color("pink") t(-d,0,0) r(180,0,0) hingeSide();
    t(0,-(l-4),0) hingeBridge();
}

module legCap(){
    difference(){
        union(){
            b(26,8,h);
            t(0,6,0) r(90,0,0) c(20,25);
        }
        t(0,9,0)  r(90,0,0) c(20,22); // pipe mounting hole
        t(0,10,0) r(0,90,0) c(30,3);  // pipe screw hole
        t(0,10,0)           c(30,3);  // pipe screw hole
        t(8,0,0)  r(90,0,0) c(20,3);  // leg attachment screw hole
        t(-8,0,0) r(90,0,0) c(20,3);  // leg attachment screw hole
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
    gteeth  = 19;
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
    t(0,-195,0) r(0,0,180) flatten() frame();
    t(0,-195,0) r(0,0,180) hingeAssembly();

    t(-60,-195,0) r(0,90,0) cap();
    t(0,-260,0) r(180,0,0) legCap();

    t(0,-180,0) r(90,0,0) dgear();
    t(-15,-195,0) r(90,0,90) dgear();
    t(15,-195,0) r(90,0,-90) dgear();

%   t(0,-360,0) rx() c(200,21.5);     // pvc pipe
%   t(0,-98,0) r(90,0,0) c(140,21.5); // pvc pipe
%   t(60,0,0) r(0,90,0) c(66,21.5);   // pvc pipe
} else { // rendering for 3D printing
    flatten() frame();
    t(120,40,0) cap();
    t(120,0,0) r(90,0,0) legCap();
    t(70,40,0) r(180,90,0) hingeSide();
    t(100,-40,0) r(0,90,90) hingeSide(); // need two printed
    t(0,-50,0) hingeBridgeSupported();
    t(80,80,0) dgear();
    t(40,80,0) dgear();
    t(0,80,0)  dgear();
}
