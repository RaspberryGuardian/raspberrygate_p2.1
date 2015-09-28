echo 18 > /sys/class/gpio/export
# then gpio18 is created

echo in > /sys/class/gpio/gpio18/direction
echo high > /sys/class/gpio/gpio18/direction

# push button then value from 1 to 0
 
watch cat /sys/class/gpio/gpio18/value

