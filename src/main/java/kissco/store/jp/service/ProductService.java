package kissco.store.jp.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kissco.store.jp.dao.ProductDAO;
import kissco.store.jp.model.CategoryVO;
import kissco.store.jp.model.ProductVO;

@Service
public class ProductService {
	
	@Autowired
	ProductDAO productdao;

	public boolean productUpload(ProductVO product) throws Exception {
		return productdao.productUpload(product);
	}


	public boolean productDelete(int product_no) {
		return productdao.productDelete(product_no);
		
	}
	public boolean productUpdate(ProductVO product) {
		// TODO Auto-generated method stub
		return productdao.productUpdate(product);
	}

	public ProductVO productInfo(int product_no) {
		// TODO Auto-generated method stub
		return productdao.productInfo(product_no);
	}


	public List<ProductVO> productList() {
		// TODO Auto-generated method stub
		return productdao.productList();
	}


	public String category(int category_no) {
		// TODO Auto-generated method stub
		return productdao.category(category_no);
	}


	public List<ProductVO> productList(int user_no) {
		// TODO Auto-generated method stub
		return productdao.productList(user_no);
	}
	
	public List<ProductVO> productListALL(String word, int min, int max, String p_sort, int page){
		return productdao.productListALL(word, min, max, p_sort, page);
	}
	
	public List<ProductVO> productListByCategory(int category_no, String word, int min, int max, String p_sort, int page){
		return productdao.productListByCategory(category_no, word, min, max, p_sort, page);
	}


	public int productTotalCnt(String word) {
		return productdao.productTotalCnt(word);
	}
	
	public int productTotalCntByCategory(int category_no, String word) {
		return productdao.productTotalCntByCategory(category_no, word);
	}
	
	public List<CategoryVO> listByCategory(){
		return productdao.listByCategory();
	}
	
	public int[] min_maxPriceALL() {
		return productdao.min_maxALL();
	}
	
	public int[] min_maxPriceByCategory(int category_no) {
		return productdao.min_maxByCategory(category_no);
	}




}
