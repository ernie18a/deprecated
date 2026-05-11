DATABASES = {
    'default': {
        'ATOMIC_REQUESTS': True,
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': "awx",
        'USER': "awx",
        'PASSWORD': "awxpass",
        'HOST': "postgres",
        'PORT': "5432",
    }
}

BROADCAST_WEBSOCKET_SECRET = "YmdQOXNFRXA0VkgzZll0ZG5WREh0NGNDR3NlOGRUakFhbmlqMjAyc2xDckUuX3VycUV0LXd3ZSw0cmp4WFhuRUhWcGxuR1dWbjVjOm90SVV5cVhiYUhKd0lKODE1S1gwWWtJR2M1QWF2SzhYbEtVQzRiUGZxQTpMaHFMNGlHN2E="
