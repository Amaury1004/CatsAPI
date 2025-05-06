import UIKit

class ImageDownloader {
    static let shared = ImageDownloader()
    
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("❌ Неверный URL")
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Ошибка загрузки изображения: \(error)")
                completion(nil)
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                print("❌ Не удалось декодировать изображение")
                completion(nil)
                return
            }

            DispatchQueue.main.async {
                completion(image)
            }
        }

        task.resume()
    }
}
