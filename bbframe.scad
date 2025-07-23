// BrakerBot Apr 2025 toandrey(at)yahoo.com
// Uses 1/2" pvc pipe, 608 bearings, 95mm disks from Hard Drives, HS300 servos
// Outer diameter of the 608 bearing is 22mm
// Outer diameter of the 1/2" pvc pipe is 21.5mm

use <bcstr.scad>
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
        t(-10,20,0) c(30,3);               // brake mounting hole in bearing block
        t(10,20,0)  c(30,3);               // brake mounting hole in bearing block
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
        t(1.5,33,0) c(30,3);        // brake mounting hole
    }
}

module hingeAssembly(){ // for visualization
    d = w/2+4;
    color("yellow") t(d,0,0)  r(180,180,0) hingeSide();
    color("pink") t(-d,0,0) r(180,0,0) hingeSide();
    t(0,-(l-4),0) hingeBridge();
}

module leg(){
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


module servoMount1(){
    difference(){
        t(0,0,3)     b(20,12,26);     // mount with holes
        t(0,0,-10.7) rx() c(20,21.5); // pvc pipe cutout
        t(0,3,15.1)  b(1.8,10,2);     // servo slot on top
        t(5,3,0)     c(50,3);         // servo mounting hole
        t(-5,3,0)    c(50,3);         // servo mounting hole
        t(0,-8,8)    r(-11.75,0,0) b(22,10,30); // face cut
        t(0,-9.5,0)  b(22,10,30);     // vertical face cut
    }
}

module servoMount(){
    union(){
        servoMount1();
        t(0,60,0)r(0,0,180) servoMount1();
        t(11.5,30,13.5) b(3,62.45,5);
        t(-11.5,30,13.5) b(3,62.45,5);
    }
}

module pad(){
    difference(){
        union(){
            c(16,30);
            t(-12, 10,0) c(16,6);
            t(-12,-10,0) c(16,6);
        }
        t(-1,0,0) c(14,25); // scoop
        t(-12, 10,0) c(20,3); // screw hole
        t(-12,-10,0) c(20,3); // screw hole
        t(-12,-11,0) b(10,7,4); // cutout
        t(6,0,0) b(30,40,20); // big block
//        t(0,15,0) b(30,30,30); // thickness checker
        t(-21,0,0) difference(){
            c(1,20);
            c(1,18.4);
        } // pin holes for attaching a brakepad
    }
}


if($preview){
    t(120,0,0) r(90,90,0) flatten() frame();
    t(120,0,0) r(90,90,0) hingeAssembly();
    flatten() frame();
    hingeAssembly();
    t(0,-195,0) flatten() frame();
    t(0,-195,0) hingeAssembly();

    t(60, -195, 0) r(0,-90,0) cap();
    t(0,-130,0) leg();
%   t(0,-330,0) rx() c(200,21.5);   // leg pvc pipe / visual aid
%   t(0,-74,0)r(90,0,0) c(91,21.5); // pvc pipe / visual aid
    dgear();
    t(0, 90, 0) servoMount();
    t(21.5,-43, -18) pad();
    t(8,-43,-18) r(0,180,0) pad();
} else { // rendering for 3D printing
    flatten() frame();
    t(-70,-40,0) cap();
    t(70,40,0) r(180,90,0) hingeSide();
    t(100,-40,0) r(0,90,90) hingeSide(); // need two printed
    t(0,-50,0) hingeBridgeSupported();
    t(80,80,0) dgear();
    t(40,80,0) dgear();
    t(0,80,0)  dgear();
    t(-40,80,0) r(180,0,0) servoMount();
    t(-80,80,0) r(180,0,0) servoMount();
    t(-60,40,0) r(0,90,0) pad();
    t(-90,40,0) r(0,90,0) pad();
    t(-120,40,0) r(0,90,0) pad();
    t(-90,0,0) r(0,90,0) pad();
}
