import tensorflow as tf
tf.compat.v1.disable_eager_execution()

# Increase the batch size
batch_size = 32

with tf.device('/GPU:0'):
    a = tf.constant([[1.0, 2.0], [3.0, 4.0]])
    b = tf.constant([[5.0, 6.0], [7.0, 8.0]])
    c = tf.matmul(a, b)

with tf.compat.v1.Session() as sess:
    sess.run(tf.compat.v1.global_variables_initializer())
    sess.graph.finalize()
    while True:
        # Increase the batch size by repeating the inputs
        inputs = tf.tile(c, [batch_size, 1, 1])
        result = sess.run(inputs)
        print(result)
