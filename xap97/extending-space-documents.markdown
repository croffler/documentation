---
layout: post
title:  Extending
categories: XAP97
parent: document-api.html
weight: 100
---

{% summary %}Extending the SpaceDocument class{% endsummary %}

# Overview

While documents provide us with a dynamic schema, they force us to give up Java's type-safety for working with typeless key-value pairs. GigaSpaces supports extending the SpaceDocument class to provide a type-safe wrapper for documents which is much easier to code with, while maintaining the dynamic schema.

{% comment %}
![document_arch.jpg](/attachment_files/document_arch.jpg)
{% endcomment %}

{%comment%}
{% plus %} Do not confuse this with [Document-POJO interoperability](./document-pojo-interoperability.html), which is a different feature.
{%endcomment%}

# Definition

Let's create a type-safe document wrapper for the **Product** type described in the [Document Support](./document-api.html) page. The extensions are:

- Provide a parameterless constructor, since the type name is fixed.
- Provide type-safe properties, but instead of using private fields to store/retrieve the values, use the getProperty/setProperty methods from the SpaceDocument class.

Here's an example (only parts of the properties have been implemented to keep the example short):

{% highlight java %}
public class ProductDocument extends SpaceDocument {
    private static final String TYPE_NAME = "Product";
    private static final String PROPERTY_CATALOG_NUMBER = "CatalogNumber";
    private static final String PROPERTY_NAME = "Name";
    private static final String PROPERTY_PRICE = "Price";

    public ProductDocument() {
        super(TYPE_NAME);
    }

    public String getCatalogNumber() {
        return super.getProperty(PROPERTY_CATALOG_NUMBER);
    }
    public ProductDocument setCatalogNumber(String catalogNumber) {
        super.setProperty(PROPERTY_CATALOG_NUMBER, catalogNumber);
        return this;
    }

    public String getName() {
        return super.getProperty(PROPERTY_NAME);
    }
    public ProductDocument setName(String name) {
        super.setProperty(PROPERTY_NAME, name);
        return this;
    }

    public float getPrice() {
        return super.getProperty(PROPERTY_PRICE);
    }
    public ProductDocument setPrice(float price) {
        super.setProperty(PROPERTY_PRICE, price);
        return this;
    }
}
{% endhighlight %}

# Registration

If your only intention is to write/update document entries, creating the extension class is sufficient - from the space's perspective it is equivalent to a `SpaceDocument` instance. However, if you attempt to read/take entries from the space, the results will be `SpaceDocument` instances, and the cast to `ProductDocument` will throw an exception.
To overcome that, we need to include the document wrapper class in the type introduction:

{% highlight java %}
public void registerProductType(GigaSpace gigaspace) {
    // Create type descriptor:
    SpaceTypeDescriptor typeDescriptor =
        new SpaceTypeDescriptorBuilder("Product")
        // ... Other type settings
        .documentWrapperClass(ProductDocument.class)
        .create();
    // Register type:
    gigaspace.getTypeManager().registerTypeDescriptor(typeDescriptor);
}
{% endhighlight %}

This wrapper type-registration is kept in the proxy and not propagated to the server, so that from the server's perspective this is still a virtual document type with no affiliated POJO class.

# Usage

The following code snippet demonstrate usage of the `ProductDocument` extensions we've created to write and read documents from the space.

{% highlight java %}
public void example(GigaSpace gigaSpace) {
    // Create a product document:
    ProductDocument product = new ProductDocument()
        .setCatalogNumber("hw-1234")
        .setName("Anvil")
        .setPrice(9.99f);
    // Write a product document:
    gigaSpace.write(product);

    // Read product document using a template:
    ProductDocument template = new ProductDocument()
        .setName("Anvil");
    ProductDocument result1 = gigaSpace.read(template);
    // Read product document using a SQL query:
    SQLQuery<ProductDocument> query = new SQLQuery<ProductDocument>("Product", "Price > ?")
        .setParameter(1, 5.5f);
    ProductDocument result2 = gigaSpace.read(query);
    // Read product document by ID:
    ProductDocument result3 = gigaSpace.readById(new IdQuery<ProductDocument>("Product", "hw-1234"));
}
{% endhighlight %}
