# Minetest Docker

This project lets you deploy a **Minetest** server using docker.

Follow the steps below to use the script.

Requirements
-------------

Make sure you have the following before using this script:

- Minetest on the machine you want to play with.

Getting started
-------------

1. **Download repository:**
    ```bash
    git clone https://github.com/quaktuss/Minetest-docker.git
2. **Make sure the script is executable by using the following command:**
   ```bash
   chmod +x start.sh
3. **Run the script :**
   ```bash
   ./start.sh <mapfolder.zip>
4. **Example**
   ```bash
   ./start.sh ~/Download/minetest_skyblock.zip


Version scheme
--------------
We use `major.minor.patch`

- Major is incremented when the release contains breaking changes, all other
numbers are set to 0.
- Minor is incremented when the release contains new non-breaking features,
patch is set to 0.
- Patch is incremented when the release only contains bugfixes and very
minor/trivial features considered necessary.