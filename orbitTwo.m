clear
clc

% Constants
G = 6.674e-11; % Gravitational constant (N * m^2 / kg^2)
m1 = 1.989e30; % Mass of the Sun (kg)
m2 = 5.972e24; % Mass of the orbiting object (kg, e.g., Earth)
r = 1.496e11; % Initial distance of the object from the Sun (1 AU in meters)

% Initial conditions
x_sun = 0; % Position of the Sun (at the origin)
y_sun = 0; % Position of the Sun (at the origin)
x_obj = r; % Initial position of the object (1 AU along the x-axis)
y_obj = 0; % Initial position of the object (1 AU along the x-axis)
vx_obj = 0; % Initial velocity of the object in the x-direction (no initial velocity)
vy_obj = 30e3; % Initial velocity of the object in the y-direction (tangential velocity)

% Initialize the Sun's velocity (since we are considering the effect on both objects)
vx_sun = 0; % Initial velocity of the Sun in the x-direction
vy_sun = 0; % Initial velocity of the Sun in the y-direction

% Time step (smaller value for smoother animation)
dt = 60 * 60 * 24 * 7; % One week per time step (in seconds)

% num steps in orbit (number of points to plot)
numSteps = 520; % Number of points in the orbit (2 years is 104 weeks)

% Set up the plot
hold on;
axis([-1.5 * r, 1.5 * r, -1.5 * r, 1.5 * r]); % scale axis to allow both Earth and Sun movement
xlabel('X Position (m)');
ylabel('Y Position (m)');
title('Earth and Sun Orbital Paths');
grid on;
axis equal;

% Initialize arrays to hold the position data
x_data_sun = zeros(1, numSteps);
y_data_sun = zeros(1, numSteps);
x_data_earth = zeros(1, numSteps);
y_data_earth = zeros(1, numSteps);

% Plot the Sun as a yellow circle
sun_marker = plot(x_sun, y_sun, 'yo', 'MarkerFaceColor', 'yellow', 'MarkerSize', 20);

% Plot the Earth as a blue circle
earth_marker = plot(x_obj, y_obj, 'bo', 'MarkerFaceColor', 'blue', 'MarkerSize', 5);

% Plot initial position of both Earth and Sun for their trails
trail_earth = plot(x_obj, y_obj, 'b-', 'LineWidth', 1);  % Earth trail in blue
trail_sun = plot(x_sun, y_sun, 'y-', 'LineWidth', 1);    % Sun trail in yellow

% Simulation loop: Update position and velocity of both the object and the Sun at each step
for t = 1:numSteps
    % Compute the distance between the object and the Sun
    r_vec = [x_sun - x_obj, y_sun - y_obj]; % Position vector of the object relative to the Sun
    r_mag = norm(r_vec); % Magnitude of the distance between the Sun and the object

    % Gravitational force between the Sun and the object (Newton's Law of Gravitation)
    F = G * m1 * m2 / r_mag^2; % Magnitude of gravitational force

    % Acceleration of the object (Earth) due to the Sun's gravity
    ax_obj = F * (x_sun - x_obj) / (m2 * r_mag); % Acceleration in the x-direction
    ay_obj = F * (y_sun - y_obj) / (m2 * r_mag); % Acceleration in the y-direction

    % Acceleration of the Sun due to the Earth's gravity
    ax_sun = -F * (x_sun - x_obj) / (m1 * r_mag); % Acceleration of Sun in x-direction
    ay_sun = -F * (y_sun - y_obj) / (m1 * r_mag); % Acceleration of Sun in y-direction

    % Update velocities and positions of both the object and the Sun
    % Update velocity of the object (Earth)
    vx_obj = vx_obj + ax_obj * dt;
    vy_obj = vy_obj + ay_obj * dt;

    % Update position of the object (Earth)
    x_obj = x_obj + vx_obj * dt;
    y_obj = y_obj + vy_obj * dt;

    % Update velocity of the Sun
    vx_sun = vx_sun + ax_sun * dt;
    vy_sun = vy_sun + ay_sun * dt;

    % Update position of the Sun
    x_sun = x_sun + vx_sun * dt;
    y_sun = y_sun + vy_sun * dt;

    % Store the position data for both Sun and Earth
    x_data_sun(t) = x_sun;
    y_data_sun(t) = y_sun;
    x_data_earth(t) = x_obj;
    y_data_earth(t) = y_obj;

    % % Update the positions of the Earth and Sun
    set(sun_marker, 'XData', x_sun, 'YData', y_sun); % Update Sun position
    set(earth_marker, 'XData', x_obj, 'YData', y_obj); % Update Earth position

    % Update the trails of the Earth and Sun
    set(trail_earth, 'XData', x_data_earth(1:t), 'YData', y_data_earth(1:t));
    set(trail_sun, 'XData', x_data_sun(1:t), 'YData', y_data_sun(1:t));

    % Pause to animate the motion
    pause(0.1); % Adjust this value for smoother/slower animation
end