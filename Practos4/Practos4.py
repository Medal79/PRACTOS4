from PIL import Image
import multiprocessing
import glob
import time
import os


def handle_photo(path):
    os.makedirs("processed", exist_ok=True)

    photo = Image.open(path)

    t_start = time.time()
    photo = photo.rotate(90, expand=True)
    photo = photo.resize((800, 600), Image.LANCZOS)
    photo = photo.convert("L")
    t_end = time.time()

    name = os.path.basename(path)
    save_to = os.path.join("processed", f"out_{name}")
    photo.save(save_to)

    return save_to, t_end - t_start


def sequential_mode(file_list):
    print("\nРежим: последовательный")
    results = [handle_photo(f) for f in file_list]

    total_time = sum(t for _, t in results)
    for path, _ in results:
        print(f"  -> {path}")
    print(f"  Время обработки: {total_time:.3f} сек")
    return total_time


def parallel_mode(file_list, num_workers=4):
    print(f"\nРежим: параллельный (workers={num_workers})")
    with multiprocessing.Pool(processes=num_workers) as pool:
        results = pool.map(handle_photo, file_list)

    total_time = sum(t for _, t in results)
    for path, _ in results:
        print(f"  -> {path}")
    print(f"  Время обработки: {total_time:.3f} сек")
    return total_time


if __name__ == "__main__":
    photos = sorted(glob.glob("images/*.jpg"))

    if not photos:
        print("Изображения не найдены в папке images/")
        exit(1)

    print(f"Обнаружено файлов: {len(photos)}")
    for p in photos:
        print(f"  {p}")

    seq_time = sequential_mode(photos)
    par_time = parallel_mode(photos, num_workers=4)

    print("\nРезультаты")
    print(f"  Последовательно : {seq_time:.3f} сек")
    print(f"  Параллельно     : {par_time:.3f} сек")
    print("\n  Файлы сохранены в папку: processed/")