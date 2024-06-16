extends Object
class_name MinHeap

var heap: Array = []
var map: Dictionary
var greater: Callable


func _init(greater_function: Callable = default_greater, elements: Array = []):
	greater = greater_function
	for e in elements:
		push(e)


func default_greater(a, b) -> bool:
	return a > b


func parent(i: int) -> int:  
	return (i - 1) / 2


func left_child(i: int):  
	return 2 * i + 1


func right_child(i: int):  
	return 2 * i + 2  


func swap(i: int, j: int) -> void:
	var i_element = heap[i]
	var j_element = heap[j]
	heap[i] = j_element
	map[j_element] = i
	heap[j] = i_element
	map[i_element] = j


func swim(index: int) -> void:
	while (index > 0 and greater.call(heap[parent(index)], heap[index])):
		swap(index, parent(index))
		index = parent(index)


func smaller_child(index: int) -> int:
	if (
		right_child(index) < heap.size()
		and greater.call(heap[left_child(index)], heap[right_child(index)])
	):
		return right_child(index)
	else:
		return left_child(index)


func sink(index: int) -> void:
	while left_child(index) < heap.size():
		var child_index := smaller_child(index)
		if greater.call(heap[index], heap[child_index]):  
			swap(index, child_index)
			index = child_index 
		else:  
			break


func is_empty():
	return heap.is_empty()


func get_min() -> Variant:
	return null if is_empty() else heap[0]


func push(element) -> void:
	heap.push_back(element)
	var index := heap.size() - 1;
	map[element] = index
	swim(index)


func pop() -> Variant:
	if is_empty():
		return null
	var top = heap[0]
	delete(top)
	return top


func delete(element) -> void:
	var index: int = map[element]
	swap(index, heap.size() - 1)
	heap.pop_back()
	sink(0)
