#include <BlynkSimpleEsp8266.h>
#include <ESP8266WiFi.h>

#define BLYNK_TEMPLATE_ID "TMPLehdDRY8Q"
#define BLYNK_DEVICE_NAME "Khí gasCopy"
#define BLYNK_AUTH_TOKEN "DcWnSl5UEL5je8DgUeqsKsEaLvi1kb-M"

char auth[] = "DcWnSl5UEL5je8DgUeqsKsEaLvi1kb-M";
char wifi[] = "Long1234";
char password[] = "long12345";

int RED = 12;
int GREEN = 14;
int buzzer = 16;
int smokeA0 = A0;
int sensorThreshold = 400;

int switch_btn = 1;

void setup() {
  pinMode(RED, OUTPUT);
  pinMode(GREEN, OUTPUT);
  pinMode(buzzer, OUTPUT);
  pinMode(smokeA0, INPUT);
  Serial.begin(9600);
  Blynk.begin(auth, wifi, password, "blynk.cloud", 80);
  Blynk.virtualWrite(V3, switch_btn);
}

BLYNK_WRITE(V3)
{
  switch_btn = param.asInt();
  Serial.println(switch_btn);
}

void checkConnection()
{
  if (!Blynk.connected())
  {
    Blynk.setProperty(V0, "color", "#D3435C");
  }
  else
  {
    Blynk.setProperty(V0, "color", "#23C48E");
  }
}

void updateAlertLevel()
{
  int analogSensor = analogRead(smokeA0);
  if (analogSensor < 200)
  {
    Blynk.virtualWrite(V2, "LOW");
    Blynk.setProperty(V0, "color", "#23C48E");
  }
  else if (analogSensor < 400)
  {
    Blynk.virtualWrite(V2, "MEDIUM");
    Blynk.setProperty(V0, "color", "#ED9D00");
  }
  else
  {
    Blynk.virtualWrite(V2, "HIGH");
    Blynk.setProperty(V0, "color", "#D3435C");
  }
  
}

BLYNK_CONNECTED() {
    Blynk.syncAll();
}

void loop() {
  Blynk.run();
  checkConnection();
  if (switch_btn == 1)
  {
    int analogSensor = analogRead(smokeA0);
    Blynk.virtualWrite(V0, analogSensor);
    if (analogSensor > sensorThreshold)
    {
      digitalWrite(RED, HIGH);
      digitalWrite(GREEN, LOW);
      tone(buzzer, 1000, 200);
    }
    else
    {
      digitalWrite(RED, LOW);
      digitalWrite(GREEN, HIGH);
      noTone(buzzer);
    }
    delay(100);
  }
  else
  {
    digitalWrite(GREEN, LOW);
    digitalWrite(RED, LOW);
  }
}