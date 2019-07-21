int main() {
  if (!digitalRead(1)) {
    digitalWrite(2, LOW);
  }
}
