import tensorflow as tf

# Set the GPU memory growth option
gpus = tf.config.experimental.list_physical_devices('GPU')
if gpus:
    try:
        for gpu in gpus:
            tf.config.experimental.set_memory_growth(gpu, True)
    except RuntimeError as e:
        print(e)

# Increase the batch size
batch_size = 32

# Use the GPU for computations
with tf.device('/GPU:0'):
    a = tf.constant([[1.0, 2.0], [3.0, 4.0]])
    b = tf.constant([[5.0, 6.0], [7.0, 8.0]])
    c = tf.matmul(a, b)

# Create a TensorFlow session
with tf.compat.v1.Session(config=tf.compat.v1.ConfigProto(log_device_placement=True)) as sess:
    sess.run(tf.compat.v1.global_variables_initializer())
    sess.graph.finalize()
    
    while True:
        # Increase the batch size by repeating the inputs
        inputs = tf.tile(c, [batch_size, 1, 1])
        result = sess.run(inputs)
        print(result)
