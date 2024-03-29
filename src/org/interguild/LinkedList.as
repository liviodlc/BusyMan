package org.interguild {
	
	/**
	 * LinkedList with built-in iterator.
	 */
	public class LinkedList {
		
		// Elements of the linked list
		private var head:Node;
		private var iterator:Node;
		
		
		/**
		 *  No arg constructor for linked list. Initializes
		 *  all var to null.
		 *
		 */
		public function LinkedList() {
			// Initializing to null
			head = null;
			iterator = null;
		}
		
		
		/**
		 *  Checking if list is empty.
		 */
		public function isEmpty():Boolean {
			// null head is an empty list
			return head == null;
		}
		
		
		/**
		 * Checking if there are more elements in the list.
		 */
		public function hasNext():Boolean {
			// null iterator is done with list
			return iterator != null;
		}
		
		
		/**
		 *  Getting next item in list.
		 */
		public function get next():Object {
			var n:Object = iterator.object;
			iterator = iterator.next;
			return n;
		}
		
		
		/**
		 * Resetting iteration to beginning of list.
		 */
		public function beginIteration():void {
			// reset to head
			iterator = head;
		}
		
		
		/**
		 * Removing all elements from list
		 */
		public function clear():void {
			// Remove all objects from list
			iterator = head = null;
		}
		
		
		/**
		 * Add object to list. Insert at head.
		 */
		public function add(toAdd:Object):void {
			// addition become new head
			head = new Node(toAdd, head);
		}
		
		
		/**
		 * Returns true if the object exists in the list.
		 */
		public function contains(obj:Object):Boolean {
			var n:Node = head;
			while (n != null) {
				if (n.object == obj)
					return true;
				n = n.next;
			}
			return false;
		}
		
		
		/**
		 * Remove object from list.
		 */
		public function remove(toRemove:Object):void {
			var traverse:Node = head;
			
			// empty list, just quit.
			if(traverse == null)
				return;
			
			// Special case, removed object is currently head
			if (head.object == toRemove) {
				head = head.next;
				return;
			}
			
			// Traverse thru the list
			while (traverse.next != null) {
				// If next element is object to remove...
				if (traverse.next.object == toRemove) {
					// Remove it
					traverse.next = traverse.next.next;
					return;
				}
				traverse = traverse.next;
			}
		}
		
		
		/**
		 * Returns a LinkedList that is an exact duplicate of this one.
		 */
		public function clone():LinkedList {
			var result:LinkedList = new LinkedList();
			var stack:LinkedList = new LinkedList();
			
			this.beginIteration();
			while (this.hasNext()) {
				stack.add(this.next);
			}
			
			stack.beginIteration();
			while (stack.hasNext()) {
				result.add(stack.next);
			}
			
			return result;
		}
	}
}

/**
 * Node elements of list above. Stores next node
 * and current node object.
 */
internal class Node {
	
	// Elements of a node
	private var obj:Object;
	private var nex:Node;
	
	
	/**
	 * Node constructor. Define object and node next
	 */
	public function Node(o:Object, n:Node) {
		
		obj = o;
		nex = n;
		
	}
	
	
	/**
	 * Get next node in list.
	 */
	public function get next():Node {
		
		return nex;
		
	}
	
	
	/**
	 * Set next node in list
	 */
	public function set next(n:Node):void {
		
		nex = n;
		
	}
	
	
	/**
	 * Get current node's stored object.
	 */
	public function get object():Object {
		
		return obj;
		
	}
	
}