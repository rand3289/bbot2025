// BrakerBot2025 toandrey(at)yahoo.com
// Brakes actuated by servo motors (not shown) transfer torque from disks to limbs
// Print everything with 0.3mm layers without support
// Uses 1/2" pvc pipe, 608 bearings, 95mm disks from Hard Drives, HS300 servos
// Every joint uses four or five bearings (not shown), 2 disks and 3 gears
//
// Outer diameter of the 608 bearing is 22mm.  ID 8mm
// Outer diameter of the 1/2" pvc pipe is 21.5mm
// TODO: redesign second side of the frame to match the other side
// make it longer.  make it symmetrical

use <bcstr.scad> // b(),c(),s(),t(),r()
include <BOSL2/std.scad>
include <BOSL2/gears.scad>
$fn=128; // make cylinders a bit rounder
w = 34; // outer frame width
l = 57; // outer frame length
h = 16; // frame height
shaft_round = 8; // 608 bearings fit an 8mm round shaft
// if you grind an end of a round shaft into a square, it will be this size
shaft_square = sqrt(shaft_round*shaft_round/2);
echo("Shaft end square size", shaft_square);

module flatten(top=8){ // remove everything below top
    intersection(){
        children();
        t(0,0,100-top) b(200,200,200); // introduces a visual glitch
    }
}

module cframe(){
    difference(){
        t(0,l/2,0) b(66,l,h);
        b(50,(l-8)*2,h+1);
    }
}

module frame(){
    d = 33;
    difference(){
        union(){
            cframe();
            flatten() t(29,0,0) r(0,90,0) c(24,25); // bearing block
            flatten() t(-d,0,0) r(0,90,0) c(32,25); // bearing block
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
    difference(){
        union(){
            b(w+20,8,16); // beam
            flatten()  t(0,15,0) r(90,0,0) c(38,25); // bearing block
            t(0,15,-4) b(25,38,8); // make bearing block bottom square
        }
        t(0,11.5,0) r(90,0,0)  c(42,22); // pipe and bearing hole
        r(90,0,0)   c(100,11);           // shaft hole
        t(21,0,0)   b(8.2,12,10.2);      // hole for hinges
        t(-21,0,0)  b(8,12,10);          // hole for hinges
        r(0,90,0)   c(60,3);             // 2 screw holes
        t(0,0,13.3) c(4,3);              // screw hole in bearing block. 13.3 for "print support"
    }
}

module hingeSide(){
    difference(){
        union(){
            r(0,90,0) c(8,28.8);  // pipe
            t(0,30,0) b(8,38,h);  // side
            t(0,52,0) b(8,10,10); // bridge connector
        }
        r(0,90,0) c(10,26);          // hinge hole
        t(0,53,0) r(0,90,0) c(10,3); // screw hole
    }
}

module hingeAssembly(){ // for visualization
    color("yellow") t(21,0,0)  r(180,180,0) hingeSide();
    color("yellow") t(-21,0,0) r(180,0,0)   hingeSide();
    color("green")  t(0,-(l-4),0)           hingeBridge();
}

module legCap(){ // attaches pipe to lower joint
    flatten(21.5/2) // shave top off this cap level with pipe
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

module cap(){ // side cap for the lower joint
    difference(){
        c(16, 28);                    // cap body
        t(0,0,1.5) c(16,22.2);        // bearing hole (.2 tolerance)
        t(0,0,8.5) c(16,25);          // slides over bearing block
        t(-10,0,4) r(0,90,0) c(30,3); // 1 screw hole
        t(0,0,4)   r(90,0,0) c(30,3); // 2 screw holes
        t(5,0,0)   c(20,3);           // bottom hole to help take out the bearing
        t(-5,0,0)  c(20,3);           // bottom hole
    }
}

// differential gear with a square shaft hole
module dgear(){
    disk_id = 25.2; // .2 for tolerance
    gteeth  = 14;
    shaft_hole = shaft_square + 0.3; // + tolerance

    difference(){
        union(){
            t(0,0,4.5)  bevel_gear(teeth=gteeth, mate_teeth=gteeth, mod=1.5, cutter_radius=0, spiral=0, shaft_diam=1);
            t(0,0,2.25) c(2, 18);        // base disk to gear connector
            t(0,0,0.4)  c(1.8, disk_id); // base for mounting a brake disk
            t(0,0,-0.9) c(0.9,27);       // brake disk endstop
        }
        b(shaft_hole,shaft_hole,20);
    }
}

module axle1(len){
    t(0,0,3.5) b(shaft_square,shaft_square,len); // 1 gear mount
    c(len-7,shaft_round);                        // bearings
}

module axle2(len){
    b(shaft_square,shaft_square,len); // 2 gear mounts
    c(len-14,shaft_round);            // bearings
}

// spacer between two bearings around axle1() to lock bearings in place
module sleve(){
    pipe(14.1, 8.2+1.8, 8.2); // len, od, id // 0.9mm wall
}


if($preview){
    t(-100,0,0) axle1(39);  // 2 per joint. actual length
    t(-120,0,0) axle2(100); // arbitrary length shown
    t(-80,0,0)  sleve();    // spacer between bearings

    t(120,0,0) r(90,90,0) frame();
    t(120,0,0) r(90,90,0) hingeAssembly();
    frame();
    hingeAssembly();
    t(0,-195,0) r(0,0,180) frame();
    t(0,-195,0) r(0,0,180) hingeAssembly();

    t(-60,-195,0) r(0,90,0)    cap();
    t(0,-260,0)   r(180,180,0) legCap();

    t(0,-180,0)   r(90,360/28,0) dgear(); // 14 teeth. rotate 1/2 tooth
    t(-15,-195,0) r(90,0,90)     dgear();
    t(15,-195,0)  r(90,0,-90)    dgear();

%   t(0,-360,0)   r(90,0,0) c(200,21.5); // pvc pipe
%   t(0,-98,0)    r(90,0,0) c(140,21.5); // pvc pipe
%   t(60,0,0)     r(0,90,0) c(66,21.5);  // pvc pipe
%   t(15,-195,0)  r(0,90,0) c(1.5,95);   // brake disk
%   t(-15,-195,0) r(0,90,0) c(1.5,95);   // brake disk
} else { // rendering for 3D printing
    t(-50,50,0)  r(90,45,0) axle1(39); // fixed length for each joint
    t(-70,50,0)  r(90,45,0) axle1(39); // need 2 per joint
    t(-70,-20,0) sleve();              // need 2 per joint
    t(-70,0,0)   sleve();
    // axle2(len) // len depends on PVC pipe length
    t(120,40,0)  cap();
    t(120,0,0)   r(90,0,0)   legCap();
    t(70,40,0)   r(180,90,0) hingeSide();
    t(100,-40,0) r(0,90,90)  hingeSide(); // need two printed
    t(0,-50,0)   hingeBridge();
    frame();
    t(80,80,0)   dgear();
    t(40,80,0)   dgear();
    t(0,80,0)    dgear();
}
