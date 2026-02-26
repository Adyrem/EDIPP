import io
from PIL import Image
from flask import Response

def image_downscale(request):
    if request.method == "OPTIONS":
        return ("", 204, {
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "POST",
            "Access-Control-Allow-Headers": "Content-Type"
        })

    if request.method != "POST":
        return "Only POST allowed", 405

    if "file" not in request.files:
        return "No file provided", 400

    file = request.files["file"]
    image = Image.open(file.stream)
    image = image.resize((100, 100))

    output = io.BytesIO()
    image.save(output, format="PNG")
    output.seek(0)

    return (
        output.read(),
        200,
        {
            "Content-Type": "image/png",
            "Access-Control-Allow-Origin": "*"
        }
    )
