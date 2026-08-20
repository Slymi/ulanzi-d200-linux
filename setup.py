from setuptools import setup, find_packages

setup(
    name="ulanzi-manager",
    version="0.1.0",
    description="Ulanzi D200 StreamDeck device manager for Linux",
    author="Lucas",
    packages=find_packages(),
    install_requires=[
        "pyusb>=1.3.1",
        "hidapi>=0.15.0",
        "pyyaml>=6.0.3",
        "obsws-python>=1.8.0",
        "pillow>=12.3.0",
        "python-daemon>=3.1.2",
    ],
    entry_points={
        "console_scripts": [
            "ulanzi-manager=ulanzi_manager.cli:main",
            "ulanzi-daemon=ulanzi_manager.daemon:main",
        ],
    },
    python_requires=">=3.10",
)
