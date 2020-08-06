package kissco.store.jp.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import kissco.store.jp.model.CategoryVO;
import kissco.store.jp.model.ProductVO;
import kissco.store.jp.model.UserVO;
import kissco.store.jp.model.WishlistVO;
import kissco.store.jp.service.ProductService;
import kissco.store.jp.service.UserService;

@Controller
@RequestMapping("/product")
public class ProductController {

	@Autowired
	ProductService productService;

	@Autowired
	UserService userService;

	// 상품detail
	@GetMapping("/detail")
	public String productDetail(@RequestParam("product_no") int product_no, Model model) {

		ProductVO product = productService.productInfo(product_no);
		UserVO user = userService.getUserByNo(product.getUser_no());
		String category = productService.category(product.getCategory());
		List<ProductVO> productList = productService.productList(user.getUser_no());
		int user_no = 0;
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		if(!authentication.getName().equals("anonymousUser")) {
			System.out.println("authentication.getName(): "+authentication.getName());
			UserVO userCheck = userService.getUserById(authentication.getName());
			user_no = userCheck.getUser_no();
		}
		System.out.println("user_no: " + user_no);

		/* String[] images = product.getPhotopath().split(","); */

		model.addAttribute("product", product);
		model.addAttribute("user", user);
		model.addAttribute("category", category);
		model.addAttribute("productList", productList);
		model.addAttribute("user_no", user_no);

		/* model.addAttribute("images", images); */
		return "detail";
	}

	@GetMapping("/upload")
	public String productUpload(Model model) {

		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		UserVO user = userService.getUserById(authentication.getName());

		ProductVO product = new ProductVO();

		product.setUser_no(user.getUser_no());
		product.setLat(user.getLat());
		product.setLng(user.getLng());

		model.addAttribute("product", product);
		model.addAttribute("categoryList", productService.listByCategory());

		return "upload";
	}

	@GetMapping("/update")
	public String productUpdate(int product_no, Model model) {

		System.out.println("product_no: " + product_no);

		ProductVO product = productService.productInfo(product_no);
		model.addAttribute("categoryList", productService.listByCategory());
		model.addAttribute("product", product);

		return "update";

	}

	// 상품 업로드
	@PostMapping(value = "/upload")
	@ResponseBody
	public boolean productUpload(ProductVO product, MultipartFile[] files, HttpServletRequest request)
			throws Exception {

		System.out.println(product.toString());
		int count = 0;
		String url = "";

		// Random Fild Id
		UUID uuid = UUID.randomUUID();

		// security 추가하면 userid값은 이렇게 받아야함!!
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		UserVO user = userService.getUserById(authentication.getName());
		product.setUser_no(user.getUser_no());
		if (files.length > 4 || files.length == 0) {
			return false;

		} else {
			for (MultipartFile file : files) {

				String rootDirectory = request.getSession().getServletContext().getRealPath("/");
				String photopath = rootDirectory + "\\resources\\productimg\\" + uuid + file.getOriginalFilename();
				System.out.println(photopath);
				Path savePath = Paths.get(photopath);
				if (count == 0) {
					product.setSumnail("\\resources\\productimg\\" + uuid + file.getOriginalFilename());
				}
				count++;
				url += "\\resources\\productimg\\" + uuid + file.getOriginalFilename() + ",";

				if (file.isEmpty() == false) {
					System.out.println("------------file start --------------------");
					System.out.println("name: " + file.getName());
					System.out.println("filename: " + file.getOriginalFilename());
					System.out.println("size: " + file.getSize());
					System.out.println("savePath: " + savePath);
					System.out.println("------------file end ---------------------");
				}

				if (file != null && !file.isEmpty()) {
					try {
						System.out.println("파일저장 시작");
						file.transferTo(new File(savePath.toString()));
					} catch (IllegalStateException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}

			}

			product.setPhotopath(url);
			return productService.productUpload(product);
		}

	}

	// 상품 삭제
	@PostMapping(value = "/delete")
	@ResponseBody
	public boolean productDelete(int product_no, HttpServletRequest request) {

		ProductVO product = productService.productInfo(product_no);
		String[] photopaths = product.getPhotopath().split(",");

		String rootDirectory = request.getSession().getServletContext().getRealPath("/");
		System.out.println("rootDirectory: " + rootDirectory);

		for (String deletePhoto : photopaths) {

			Path deletePath = Paths.get(rootDirectory + deletePhoto);
			System.out.println("delete path: " + deletePath);

			if (Files.exists(deletePath)) {
				try {
					System.out.println("파일삭제 됨!!");
					Files.delete(deletePath);
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}

		return productService.productDelete(product_no);

	}

	// 상품 수정
	@PostMapping(value = "/update")
	@ResponseBody
	public boolean productUpdate(ProductVO product, MultipartFile[] files, HttpServletRequest request) {

		System.out.println("product_update: " + product.getProduct_no());

		// 사진 삭제 부분!!!
		ProductVO beforeProduct = productService.productInfo(product.getProduct_no());
		String[] photopaths = beforeProduct.getPhotopath().split(",");

		String rootDirectory = request.getSession().getServletContext().getRealPath("/");
		System.out.println("rootDirectory: " + rootDirectory);

		for (String deletePhoto : photopaths) {

			Path deletePath = Paths.get(rootDirectory + deletePhoto);
			System.out.println("delete path: " + deletePath);

			if (Files.exists(deletePath)) {
				try {
					System.out.println("파일삭제 됨!!");
					Files.delete(deletePath);
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}

		System.out.println(product.toString());
		int count = 0;
		String url = "";

		// Random Fild Id
		UUID uuid = UUID.randomUUID();

		// security 추가하면 userid값은 이렇게 받아야함!!
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		UserVO user = userService.getUserById(authentication.getName());
		product.setUser_no(user.getUser_no());

		if (files.length > 4) {
			return false;

		} else {
			for (MultipartFile file : files) {

				String photopath = rootDirectory + "\\resources\\productimg\\" + uuid + file.getOriginalFilename();
				System.out.println(photopath);
				Path savePath = Paths.get(photopath);
				if (count == 0) {
					product.setSumnail("\\resources\\productimg\\" + uuid + file.getOriginalFilename());
				}
				count++;
				url += "\\resources\\productimg\\" + uuid + file.getOriginalFilename() + ",";

				if (file.isEmpty() == false) {
					System.out.println("------------file start --------------------");
					System.out.println("name: " + file.getName());
					System.out.println("filename: " + file.getOriginalFilename());
					System.out.println("size: " + file.getSize());
					System.out.println("savePath: " + savePath);
					System.out.println("------------file end ---------------------");
				}

				if (file != null && !file.isEmpty()) {
					try {
						System.out.println("파일저장 시작");
						file.transferTo(new File(savePath.toString()));
					} catch (IllegalStateException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}

			}

			product.setPhotopath(url);
			return productService.productUpdate(product);
		}

	}

	// go wishlist
	@GetMapping("/wishList")
	public String productWishList(Model model) {

		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		UserVO vo = userService.getUserById(authentication.getName());

		List<WishlistVO> wishList = userService.getWishlistVOs(vo.getUser_no());
		model.addAttribute("wishList", wishList);

		return "wishList";
	}

	@GetMapping(value = "/wishList/add")
	@ResponseBody
	public boolean wishListUpdate(int product_no) {

		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		UserVO userVO = userService.getUserById(authentication.getName());

		return userService.insertWishlist(userVO.getUser_no(), product_no);
	}

	// delete wishlist
	@GetMapping(value = "/wishList/delete")
	public String wishlistDelete(int product_no) {

		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		UserVO vo = userService.getUserById(authentication.getName());

		userService.deleteWishlist(product_no, vo.getUser_no());

		return "redirect:/product/wishList";
	}

	// delete wishlistAll
	@GetMapping(value = "/wishList/deleteAll")
	public String wishlistDelete() {

		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		UserVO vo = userService.getUserById(authentication.getName());

		if (!userService.deleteWishlistALL(vo.getUser_no())) {
			System.out.println("실패앴어.... |" + vo.getUser_no());
		}

		return "redirect:/product/wishList";
	}

	@GetMapping(value = "/listALL")
	@ResponseBody
	public List<ProductVO> productListALL(String word, int min, int max, String p_sort, int page) {
		page = page * 9;
		return productService.productListALL(word, min, max, p_sort, page);
	}

	@GetMapping(value = "/listByCategory")
	@ResponseBody
	public List<ProductVO> productListByCategory(int category_no, String word, int min, int max, String p_sort,
			int page) {
		page = page * 9;
		return productService.productListByCategory(category_no, word, min, max, p_sort, page);
	}

	@GetMapping(value = "/totalCnt")
	@ResponseBody
	public int productTotalCnt(String word) {
		return productService.productTotalCnt(word);
	}

	@GetMapping(value = "/totalCntByCategory")
	@ResponseBody
	public int productTotalCntByCategory(int category_no, String word) {
		return productService.productTotalCntByCategory(category_no, word);
	}

	@GetMapping(value = "/category")
	@ResponseBody
	public List<CategoryVO> listByCategory() {
		return productService.listByCategory();
	}

	@GetMapping(value = "/priceALL")
	@ResponseBody
	public int[] min_maxPriceALL() {
		return productService.min_maxPriceALL();
	}

	@GetMapping(value = "/priceByCategory")
	@ResponseBody
	public int[] min_maxPriceByCategory(int category_no) {
		return productService.min_maxPriceByCategory(category_no);
	}

}
