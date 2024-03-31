[
    {
        "name": "${container_name}",
        "image": "${aws_ecr_url}:${tag}",
        "portMappings": [
            {
                "containerPort": 16261,
                "hostPort": 16261,
                "protocol": "udp"
            },
            {
                "containerPort": 16262,
                "hostPort": 16262,
                "protocol": "udp"
            }
        ]
    }
]