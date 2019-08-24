/*     Simple Stepper Motor Control Exaple Code
 *  adapted from:   
 *  by Dejan Nedelkovski, www.HowToMechatronics.com
 *  
 */
// defines pins numbers

const int stepPin = 3; 
const int dirPin = 4; 
const int stepPin2 = 6; 
const int dirPin2 = 5; 

void setup() {
  // Sets the two pins as Outputs
  pinMode(stepPin,OUTPUT); 
  pinMode(stepPin2,OUTPUT); 
  pinMode(dirPin,OUTPUT);
  pinMode(dirPin2,OUTPUT);

}

void loop() {
  digitalWrite(dirPin,LOW); // Enables the motor to move in a particular direction
  digitalWrite(dirPin2,LOW); // Enables the motor to move in a particular direction
  // Makes 200 pulses for making one full cycle rotation
  for(int x = 0; x < 200; x++) {
    digitalWrite(stepPin,HIGH); 
    digitalWrite(stepPin2,HIGH); 

    delayMicroseconds(1000); 
    digitalWrite(stepPin,LOW); 
    digitalWrite(stepPin2,LOW); 

    delayMicroseconds(1000); 
  }
  delay(1000); // One second delay
  
//  digitalWrite(dirPin,LOW); //Changes the rotations direction
  // Makes 400 pulses for making two full cycle rotation
//  for(int x = 0; x < 400; x++) {
//    digitalWrite(stepPin,HIGH);
//    delayMicroseconds(1000);
//    digitalWrite(stepPin,LOW);
//    delayMicroseconds(1000);
//  }
//  delay(1000);
}
