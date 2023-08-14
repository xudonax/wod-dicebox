// What part do you want rendered
renderTop = false; // Render the lid
renderBottom = true; // Render the bottom
renderDisplay = false; // Render both parts side-by-side
renderFitCheck = false; // Render the fit check (if you see more than a thin line it won't fit together properly)

// What inlay do you want?
renderDiceInlay = true; // Render the 19 spheres to put dice in. If you do this for both sides you cannot fit a "standard" (Chessex) D4, D6, or D20
renderTrayInlay = false; // Render a tray for throwing your dice in. This will fit a "standard" (Chessex) D4, D6, and D20

// When rendering the tray, do you want a felt inlay?
// If not, set this to 0.
// Otherwise, set this to the felt thickness to make a rim to go over the felt
feltThickness = 4;

// Box size
boxHeight = 15;
boxRadius = 75; // If changing this, you'll also need to modify the translations in diceInlayPart!

// Dice size, the official VtM dice are 23mm from point to point
diceDiameter = 23;

// Change this if you want to use different magnets
magnetHeight = 3;
magnetDiameter = 5;

module hexagonShadowLine(h, dh, r, dr, w, offset=0) {
    difference() {
        cylinder(h=(h+dh), r=(r-dr+offset), $fn=6);
        translate([0, 0, -dh]) cylinder(h=(h + 3 * dh), r=(r - dr - w + offset), $fn=6);
    }
}

module hexagonBox() {
    cylinder(h=boxHeight, r=boxRadius, $fn=6);
}

module hexagonBottom() {
    union() {
        hexagonBox();
        hexagonShadowLine(h=boxHeight, r=boxRadius, dh=4, dr=3, w=3);
    }
}

module hexagonTop() {
    difference() {
        hexagonBox();
        translate([0, 0, (boxHeight - 5)]) hexagonShadowLine(h=boxHeight, r=boxRadius, dh=6, dr=3, w=4.5, offset=1);
    }
}

module diceInlay(diceDiameter = diceDiameter) {
    echo("Rendering dice with diameter ", diceDiameter);
    
    diceOffsetHeight = ((boxHeight * 2) - diceDiameter) / 2;
    zPos = diceDiameter / 2 + diceOffsetHeight;
    
    translate([0, 0, zPos]) sphere(d = diceDiameter, $fn=20);
}

module diceInlayPart() {
    translate([12.8, -47, 0]) diceInlay();
    translate([-12.8, -47, 0]) diceInlay();
    translate([0, -25.5, 0]) diceInlay();
}

module trayInlay() {
    zPos = boxHeight - diceDiameter / 2;
    radius = boxRadius - 6.4;
    
    magnetPoleHeight = 15;
    magnetPoleTopDiameter = magnetDiameter + 2.25;
    magnetPoleBottomDiameter = magnetPoleTopDiameter * 2;
    
    difference() {
        // The actual tray
        translate([0, 0, zPos]) cylinder(h=diceDiameter, r=radius, $fn=6);
        // The cylinders that hold the magnets
        rotate(a=  0) translate([-65, 0, 0]) cylinder(h=magnetPoleHeight, d2=magnetPoleTopDiameter, d1=magnetPoleBottomDiameter, $fn=6);
        rotate(a= 60) translate([-65, 0, 0]) cylinder(h=magnetPoleHeight, d2=magnetPoleTopDiameter, d1=magnetPoleBottomDiameter, $fn=6);
        rotate(a=120) translate([-65, 0, 0]) cylinder(h=magnetPoleHeight, d2=magnetPoleTopDiameter, d1=magnetPoleBottomDiameter, $fn=6);
        rotate(a=180) translate([-65, 0, 0]) cylinder(h=magnetPoleHeight, d2=magnetPoleTopDiameter, d1=magnetPoleBottomDiameter, $fn=6);
        rotate(a=240) translate([-65, 0, 0]) cylinder(h=magnetPoleHeight, d2=magnetPoleTopDiameter, d1=magnetPoleBottomDiameter, $fn=6);
        rotate(a=300) translate([-65, 0, 0]) cylinder(h=magnetPoleHeight, d2=magnetPoleTopDiameter, d1=magnetPoleBottomDiameter, $fn=6);
        // The hold-down for felt
//        if (feltThickness != 0) {
//            translate([0, 0, zPos+feltThickness]) difference(){
//                cylinder(h=1, r=radius-2, $fn=6);
//                cylinder(h=1, r=radius-4, $fn=6);
//            }
//            rotate(a=  0) translate([0, -63, zPos]) cube([2, 7, feltThickness]);
//            rotate(a= 60) translate([0, -63, zPos]) cube([2, 7, feltThickness]);
//            rotate(a=120) translate([0, -63, zPos]) cube([2, 7, feltThickness]);
//            rotate(a=180) translate([0, -63, zPos]) cube([2, 7, feltThickness]);
//            rotate(a=240) translate([0, -63, zPos]) cube([2, 7, feltThickness]);
//            rotate(a=300) translate([0, -63, zPos]) cube([2, 7, feltThickness]);
//        }
    }
}

module magnetPart() {
    translate([65, 0, (boxHeight-magnetHeight)]) 
        cylinder(h=((2*magnetHeight)+0.1), d=magnetDiameter+0.1, $fn=20);
}

module magnetInlay() {
    rotate(a=  0) magnetPart();
    rotate(a= 60) magnetPart();
    rotate(a=120) magnetPart();
    rotate(a=180) magnetPart();
    rotate(a=240) magnetPart();
    rotate(a=300) magnetPart();
}

module inlay() {
    if (renderDiceInlay) {
        {
            diceInlay(25);
        }
        rotate(a=  0) diceInlayPart();
        rotate(a= 60) diceInlayPart();
        rotate(a=120) diceInlayPart();
        rotate(a=180) diceInlayPart();
        rotate(a=240) diceInlayPart();
        rotate(a=300) diceInlayPart();
    }
    else if (renderTrayInlay) {
        trayInlay();
    }
    
    magnetInlay();
}

module logo() {
    translate([-57, -57, -3]) 
        //scale([0.3, 0.3, 1]) import("Logos/Vampire the Masquerade/Ankh.stl");
        //scale([0.3, 0.3, 1]) import("Logos/Vampire the Masquerade/Book of Nod.stl");
        translate([-6, 6, 0]) rotate(a=-8) scale([0.3, 0.3, 1]) import("Logos/Mouse.stl");
        
}

module bottom() {
    difference() {
        hexagonBottom();
        inlay();
    }
}

module top() {
    difference() {
        hexagonTop();
        inlay();
        logo();
    }
}

// Display
if (renderDisplay) {
    translate([0, -80, 0]) top();
    translate([0, 80, 0]) bottom();
}

// Bottom
else if (renderBottom) bottom();

// Top
else if (renderTop) top();

else if (renderFitCheck) {
    intersection() {
        bottom();
        translate([0, 0, (boxHeight * 2)]) rotate(a=180, v=[0, 1, 0]) top();
    }
}