import logging

logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(name)s - %(levelname)s - %(message)s")


def main():
    logger.info("Hello from uv-ruff-ty-docker-template!")


if __name__ == "__main__":
    main()
