# Layered Data Architecture

## Overview

In this architecture, each layer represents a distinct level of abstraction and is responsible for performing specific tasks related to data modeling, such as data storage, data transformation, and data presentation. This approach is commonly used in modern data warehouse and business intelligence systems, as it provides a flexible and scalable way to manage and organize complex data sets.

## Architecture Diagram

```
Data Layer → Clean Layer → Integration Layer → Object Layer → Business Layer
                                                     ↓
                                              Reporting Layer

Metadata -----> Object Layer
         -----> Business Layer  
         -----> Reporting Layer

Seeds --------> Clean Layer
```

**Data Flow:**
- **Primary Flow:** Data → Clean → Integration → Object → Business
- **Reporting Branch:** Object → Reporting  
- **Support Elements:** Metadata feeds into Object/Business/Reporting, Seeds feed into Clean

## Core Layers

The **four main layers** are defined as follows:

### 1. Data Layer

This layer represents the raw data that is collected from various sources such as databases, files, or external systems (e.g. SaaS applications). The data in this layer is typically in a normalized form, meaning that it is organized into tables with rows and columns. The primary focus of this layer is to ensure that the data is accurate, complete, and consistent.

**Responsibilities:**
- **Data Storage:** The data layer stores the data acquired from the various sources in its original format, typically in a data warehouse or a data lake. The data is stored in a way that enables efficient retrieval and processing.
- **Data Historization:** If data from source systems needs to be historized in the data warehouse because the source systems cannot meet sufficient historization requirements, the data layer is the place to do so.

### 2. Clean Layer

This layer is responsible for transforming and cleaning the raw data from the data layer. In this layer, data is filtered, de-duplicated, validated, and enriched as required. The goal of this layer is to ensure that the data is reliable and consistent across different data sources. The clean layer typically uses ETL (Extract, Transform, Load) tools or scripts to perform these transformations.

**Responsibilities:**
- **Data Consistency:** The clean layer transforms the raw data from the data layer into a consistent and structured format that can be used by the other layers in the data model. This includes tasks such as applying table and column naming conventions or ensuring data type consistency.
- **Data Quality:** The data layer ensures that the data stored is of high quality, meaning it is accurate, complete, consistent, and relevant. Data quality checks are performed on incoming data to detect and correct any errors or inconsistencies.
- **Data Optimization:** The clean layer ensures that the data is optimized for further processing. Depending on the data warehouse technology, this can include tasks such as table partitioning or index creation.

**❌ What does NOT happen in the Clean Layer:**
- JOINs
- CTEs
- Aggregations  
- Business Logic

### 3. Object Layer

This layer is responsible for creating data objects that represent business entities such as customers, products, or orders. The data objects are typically created by combining and aggregating data from the clean layer. The object layer defines the relationships between these data objects and provides a consistent representation of the data to the business layer.

**Responsibilities:**
- **Data Abstraction:** The object layer abstracts the data from the underlying source systems and presents it in a way that is intuitive for business users. This allows business users to interact with the data using familiar business terms, rather than technical database terms.
- **Core Business Definitions:** The object layer defines core business logic and rules that can be used to analyze and report on the data.

### 4. Business Layer

This layer is responsible for providing a view of the data that extends beyond the (abstract) data objects of the object layer. The business layer defines business logic, such as calculations, aggregations, and rules, that transform the data objects from the object layer into insights and actions. The primary goal of this layer is to provide a clear and concise representation of the data to the end-users, typically through reporting, dashboards, or other visualizations.

**Responsibilities:**
- **KPI Definition:** The business layer is the main point of specific KPI definitions. KPIs are defined on top of data objects and represent concrete business logic.
- **Common Aggregations:** Aggregations that are often required for analytical and reporting use cases (e.g. calculating daily sessions per user based on the sessions and user objects) can be defined and materialized in the business layer.

## Additional Layers

In addition to the four core layers introduced above, the following **additional layers** can be used:

### Integration Layer
This layer sits between the Clean Layer and the Object Layer. In some cases, data from the Clean Layer needs to be further refined before it can be used in the Object Layer. This is especially helpful when important logic pieces on individual Clean Layer tables are repeated throughout the Object Layer (e.g. if specific filters need to be applied to an event table before objects can be derived from these events). The integration layer can also be used to break up complex logic that would otherwise hinder performance or code quality of Object Layer scripts.

### Metadata
This layer holds information that is not bound to any source system but which can be useful for analytical purposes. The most common example of a metadata table is a date table that holds useful information on individual dates such as the month, quarter, year or different string representations of a date.

### Seeds
In dbt, seeds refer to static files injected into the data model. These files are materialized in a seeds layer. Most commonly, these files are manual mapping tables and provide a gateway to add custom data to the data model that is not directly accessible from the integrated sources.

### Reporting Layer
If a number of reports require optimized versions of Object Layer or Business Layer tables, these can be defined and created in the Reporting Layer. This can be specific filters applied to downstream tables or specific table join combinations that would otherwise be interpreted at the time of rendering a report.

## Layer Summary

**Data Layer**
- Purpose: Raw data storage
- Key Activities: Storage, historization
- Input: Source systems
- Output: Normalized raw data

**Clean Layer**  
- Purpose: Data quality & consistency
- Key Activities: Cleaning, validation, optimization
- Input: Raw data
- Output: Clean, consistent data

**Integration Layer**
- Purpose: Data refinement
- Key Activities: Complex transformations, filtering
- Input: Clean data
- Output: Refined data objects

**Object Layer**
- Purpose: Business entity modeling
- Key Activities: Abstraction, core business definitions
- Input: Clean/Integration data
- Output: Business entities

**Business Layer**
- Purpose: KPI & analytics
- Key Activities: KPI definitions, aggregations
- Input: Object data
- Output: Business metrics

**Reporting Layer**
- Purpose: Optimized reporting
- Key Activities: Performance optimization, specific joins
- Input: Business/Object data
- Output: Report-ready data

---

This layered approach ensures **separation of concerns**, **maintainability**, and **scalability** in modern data warehouse architectures.